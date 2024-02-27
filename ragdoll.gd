extends Node2D

@onready var draggydrag = get_tree().get_current_scene().name == "Main Menu" 
var selected = false
var velocity: Vector2
var prev:Vector2
var p:Vector2

func deleteshit(node):
	if node and node.position.y >= 2000:
		node.queue_free()
		
func _physics_process(delta):
	
	deleteshit($head)
	deleteshit($topleftleg)	
	deleteshit($toprightleg)	
	deleteshit($torso)	
	deleteshit($rightairpod)	
	deleteshit($leftairpod)	
	deleteshit($bottomrightarm)	
	deleteshit($bottomleftarm)
	deleteshit($bottomleftleg)	
	deleteshit($bottomrightleg)	
	
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

func _on_body_entered(body, limb):
	#print(body)
	if $Ragpact.playing:
		return
		
	var velocity = get_node(limb).linear_velocity.y
	#print(body)
	#print(velocity)
	if velocity < 100:
		return
		
	$Ragpact.volume_db=(velocity/150)-15
	if $Ragpact.volume_db>-7:
		$Ragpact.volume_db=-7.1
	$Ragpact.play()
