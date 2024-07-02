extends RigidBody2D
class_name Bomb

@export var power = 100
var exploded=false

func explode():
	if exploded: return
	exploded=true
	
	await Game.wait(0.1)
	
	$ExplodeSfx.play()
	
	Game.explosionatshapecast($ExplodeShape, power)
		
	$CollisionShape2D.queue_free()
	$Sprite2D.queue_free()

func enoughvel(vel:Vector2,v):
	return vel.abs().x > v or vel.abs().y > v

func tryexplode(vel:Vector2):
	if enoughvel(vel, 300):
		explode()

func _on_rigid_body_2d_body_entered(body):
	if 'velocity' in body:
		tryexplode(body.velocity)
	elif 'linear_velocity' in body:
		tryexplode(body.linear_velocity)
	
	tryexplode(linear_velocity)

# sound is done playing, bomb is truly gone now
func _on_explode_sfx_finished():
	queue_free()
