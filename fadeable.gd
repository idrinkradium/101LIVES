class_name Fadable extends CanvasItem

@onready var player = get_tree().current_scene.get_node("Player")
@export var should_fade = true
@export var distance_object = self 
@export var far= 200.0
@export var spread=20.0
@export var wait_time = 0
@export var wait_distance = 500
var wait_counter = 0.0
var f = 1

func _ready():
	modulate.a = 0
	if wait_time > 0:
		f = 0
	
func _process(delta):
	if !should_fade:
		return

	var distance = abs(player.position.x - distance_object.position.x)
	
	#print(" f:", f, " wait_distance:", wait_distance, " wait_counter:", wait_counter, " distance:", distance)
	if wait_time > 0:
		if wait_distance < distance:
			return
			
		wait_counter += delta
		
		if wait_counter < wait_time:
			return
		
		f += delta
		f = min(f, 1)
	
	if distance < far:
		modulate.a = 1 * f
	else:
		modulate.a = ((-spread/100000)*((distance-far)**2)+1) * f

