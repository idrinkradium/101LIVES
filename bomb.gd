extends Node2D

var exploded=false

func explode():
	if exploded: return
	exploded=true
	$ExplodeSfx.play()
	$RigidBody2D.queue_free()
	
func enoughvel(vel):
	var a = 100
	return vel.abs().x > a or vel.abs().y > a

func tryexplode(vel:Vector2):
	if enoughvel(vel):
		explode()

func _on_rigid_body_2d_body_entered(body):
	if 'velocity' in body:
		tryexplode(body.velocity)
	elif 'linear_velocity' in body:
		tryexplode(body.linear_velocity)
	
	tryexplode($RigidBody2D.linear_velocity)


func _on_explode_sfx_finished():
	queue_free()
