extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	pass
	#print(body.name)
	#if body.name != "torso":
		#return
	#body.constant_force.y = -100

func _on_body_exited(body):
	pass
	#if body.name != "torso":
		#return
		#
	#body.constant_force.y = 0
