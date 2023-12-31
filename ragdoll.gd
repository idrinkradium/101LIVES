extends Node2D


var selected = false
func _on_torso_input_event(viewport, event, shape_idx):
	print(event)
	if event is InputEventMouseMotion:
		if selected:
			$torso.apply_impulse(event.velocity)
		
	if event is InputEventMouseButton: 
		print(event.pressed)
		selected=event.pressed
			
