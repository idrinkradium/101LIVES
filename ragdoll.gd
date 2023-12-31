extends Node2D

@onready var draggydrag = get_tree().get_current_scene().name == "Main Menu" 
var selected = false
var velocity: Vector2
var prev:Vector2
var p:Vector2

func _physics_process(delta):
	
	if position.y >= 2000:
		print(1)
		queue_free()
	
	
	if not draggydrag:
		return
		
	prev = p
	p = get_global_mouse_position()
	if selected:
		var v = (p-prev)*50
		$torso.apply_force(v)
		$torso.apply_impulse(v)
	
	

func _on_torso_input_event(viewport, event, shape_idx):
	if not draggydrag:
		return
	
	if event is InputEventMouseButton:
		if event.pressed:
			selected=true
