extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Die"):
		var ragdoll:PackedScene = load("res://ragdoll.tscn")
		var instance = ragdoll.instantiate()
		#print("hello")
		instance.position = Vector2(300,0)
		add_child(instance)
