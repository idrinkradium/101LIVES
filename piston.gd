extends Powerable

@export var height = 150
@export var animation_duration = 0.15
@export var player_velocity = 1000

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
	
	busy = true
	powered = new_power
	
	if powered:
		$PistonOut.play()
	else:
		$PistonIn.play()

	if powered:
		for collision in $AnimatableBody2D/ShapeCast2D.collision_result:
			if collision.collider is CharacterBody2D:
				collision.collider.velocity.y = -player_velocity
	
	if tween:
		tween.kill() # Abort the previous animation.
	
	tween = create_tween()
	
	var new_y = $AnimatableBody2D.position.y - height if powered else $AnimatableBody2D.position.y + height
	tween.parallel().tween_property($AnimatableBody2D, "position", Vector2($AnimatableBody2D.position.x, new_y), animation_duration)
	
	new_y = -.0014 * height if powered else 0
	tween.parallel().tween_property($Spring, "scale", Vector2($Spring.scale.x, new_y), animation_duration)
	
	var finished = func():
		busy = false

	tween.finished.connect(finished)
	
