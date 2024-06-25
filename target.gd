extends Sprite2D
var target=false


func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		body.set_deferred("freeze", true)
		target=true


func _on_area_2d_body_exited(body):
	if body is RigidBody2D:
		body.set_deferred("freeze", false)
		target=false
