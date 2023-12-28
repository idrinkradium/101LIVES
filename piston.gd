extends Node2D

@export var height = 100

var animating = false
var bruh = false

signal power_changed(power: bool)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_down"):
		power_changed.emit(false)
	if Input.is_action_just_pressed("ui_up"):
		power_changed.emit(true)
	#if bruh and launch_body != null:
		#print(launch_body)
		#if launch_body is CharacterBody2D:
			#launch_body.velocity.y = -1000
		#elif launch_body is RigidBody2D:
			#
			#for child in launch_body.get_parent().get_children():
				#if child is RigidBody2D:
					#child.apply_impulse(Vector2(0, -2500))
					#child.apply_force(Vector2(0, -2500))
			#
		#bruh = false
		
	#if animating:
		#var y = 1.75 * delta
		#$Spring.scale.y -= y
		#$Piston.position.y -= 1260*delta #1260
		#
		#if $Spring.scale.y <= -0.22:
			#animating = false
			#
	#if Input.is_action_just_pressed("ui_home"):
		#$Spring.scale.y = 0
		#$Piston.position.y = -20
	

func _on_power_changed(power):
	animating = true
	bruh = true
	if power:
		$PistonOut.play()
	else:
		$PistonIn.play()
		
	var tween = get_tree().create_tween()
	var duration = 0.1
	
	var new_y = $Piston.position.y - height if power else $Piston.position.y + height
	tween.tween_property($Piston, "position", Vector2($Piston.position.x, new_y), duration)
	
	new_y = -.22 / height if power else 0
	tween.tween_property($Spring, "scale", Vector2($Spring.scale.x, new_y), duration)
