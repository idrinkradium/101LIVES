extends Node2D

@export var height = 150
@export var animation_duration = 0.1
@export var velocity = 1000

var power = false

signal power_changed(new_power: bool)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_down"):
		power_changed.emit(false)
	if Input.is_action_just_pressed("ui_up"):
		power_changed.emit(true)
		

func _on_power_changed(new_power):
	if power == new_power:
		return
		
	power = new_power
	
	if power:
		$PistonOut.play()
	else:
		$PistonIn.play()
		
	var tween = get_tree().create_tween()
	var new_y = $Piston.position.y - height if power else $Piston.position.y + height
	tween.parallel().tween_property($Piston, "position", Vector2($Piston.position.x, new_y), animation_duration)
	
	new_y = -.0014 * height if power else 0
	tween.parallel().tween_property($Spring, "scale", Vector2($Spring.scale.x, new_y), animation_duration)

	if power:
		for collision in $Piston/ShapeCast2D.collision_result:
			if collision.collider is CharacterBody2D:
				collision.collider.velocity.y = -velocity
			elif collision.collider is RigidBody2D:
				for child in collision.collider.get_parent().get_children():
					if child is RigidBody2D:
						child.apply_impulse(Vector2(0, -velocity))
						child.apply_force(Vector2(0, -velocity))
