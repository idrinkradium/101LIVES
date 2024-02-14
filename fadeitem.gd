class_name FadeText extends Label

@export var distance_object: Node
var should_fade = true
@export var far= 0.0
@export var spread=0.0
func _ready():
	modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !should_fade:
		return
	
	var player = get_tree().current_scene.get_node("Player")
	var distance = absf(player.position.x -distance_object.position.x)

	if distance < far:
		modulate.a = 1
		return
		
	modulate.a = (-spread/100000)*((distance-far)*(distance-far))+1
