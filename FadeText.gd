class_name FadeText extends Label

@export var distance_object: Node
var should_fade = true

func _ready():
	modulate.a = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !should_fade:
		return
	
	var player = get_tree().current_scene.get_node("Player")
	var distance = player.position.distance_to(distance_object.position)

	if distance < 100:
		modulate.a = 1
		return
		
	modulate.a = -.0001*((distance-100)*(distance-100))+1
