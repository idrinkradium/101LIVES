extends Powerable

@export var height = 150
@export var animation_duration = 0.1
@export var player_velocity = 1000

@onready var start_pos: Vector2 = $Piston.position

func _process(delta):
	if Input.is_action_just_pressed("o"):
		power_changed.emit(false)
	if Input.is_action_just_pressed("p"):
		power_changed.emit(true)
		
func _on_power_changed(new_power):
	if powered == new_power:
		return
	var y_rotation_velocity = player_velocity * cos((3.14159) * (rotation_degrees/180))
	var x_rotation_velocity = player_velocity * sin((3.14159) * (rotation_degrees/180))
	print(x_rotation_velocity,"  ",y_rotation_velocity)
	powered = new_power
	
	if powered:
		$PistonOut.play()
	else:
		$PistonIn.play()
	if powered:
		for collision in $Piston/ShapeCast2D.collision_result:
			if collision.collider is CharacterBody2D:
				collision.collider.velocity.y = -y_rotation_velocity
				collision.collider.velocity.x = x_rotation_velocity

	var tween = create_tween()
	
	var new_y =  start_pos.y - height if powered else start_pos.y
	tween.parallel().tween_property($Piston, "position", Vector2(start_pos.x, new_y), animation_duration)
	
	new_y = -.00139 * height if powered else 0
	tween.parallel().tween_property($Spring, "scale", Vector2($Spring.scale.x, new_y), animation_duration)
	var finished = func():
		$SafezoneTimer.start()

	tween.finished.connect(finished)


func _on_safezone_timer_timeout():
	if $Piston/ShapeCast2D.collision_result.is_empty():
		$Piston/CollisionPolygon2D.disabled=false
		$SafezoneTimer.stop()
