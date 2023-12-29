extends Powerable

@export var height = 150
@export var animation_duration = 0.1
@export var player_velocity = 1000
@export var ragdoll_force = 300

var tween:Tween
var busy = false

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		power_changed.emit(false)
	if Input.is_action_just_pressed("ui_up"):
		power_changed.emit(true)
		

func _on_power_changed(new_power):
	if powered == new_power or busy:
		return
	
	powered = new_power
	
	if powered:
		$PistonOut.play()
	else:
		$PistonIn.play()

	$Piston/CollisionPolygon2D.disabled=true
	busy = true
	
	if powered:
		for collision in $Piston/ShapeCast2D.collision_result:
			if collision.collider is CharacterBody2D:
				collision.collider.velocity.y = -player_velocity
			else:
				for child in collision.collider.get_parent().get_children():
					if not child is RigidBody2D:
						continue
						
					child.apply_impulse(Vector2(0, -ragdoll_force))
	
	if tween:
		tween.kill() # Abort the previous animation.
	
	tween = create_tween()
	
	var new_y = $Piston.position.y - height if powered else $Piston.position.y + height
	tween.parallel().tween_property($Piston, "position", Vector2($Piston.position.x, new_y), animation_duration)
	
	new_y = -.0014 * height if powered else 0
	tween.parallel().tween_property($Spring, "scale", Vector2($Spring.scale.x, new_y), animation_duration)
	
	var finished = func():
		$SafezoneTimer.start()
		busy = false

	tween.finished.connect(finished)
	

func _on_safezone_timer_timeout():
	if $Piston/ShapeCast2D.collision_result.is_empty():
		$Piston/CollisionPolygon2D.disabled=false
		$SafezoneTimer.stop()
