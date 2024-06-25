extends Sprite2D
var target = false
var bodies = []
var active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == true:
		for body in bodies:
			body.linear_velocity = Vector2(0,0)
	if bodies == []:
		active = false
	else: active = true


func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		bodies.append(body)
		print(body)
		target = true
		


func _on_area_2d_body_exited(body):
	if body is RigidBody2D:
		bodies.erase(body)
		target = false
