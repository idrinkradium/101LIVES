extends Node2D

var exploded=false

func explode():
	if exploded: return
	exploded=true
	$ExplodeSfx.play()
	
	for collision in $RigidBody2D/ExplodeShape.collision_result:
		if not collision.collider is RigidBody2D:
			continue
		var direction=position.direction_to(collision.collider.global_position)
		var distance=position.distance_to(collision.collider.global_position)
		var distancemulti=-.00333*(distance)+1
		var magnitude=direction*distancemulti*100
		collision.collider.apply_impulse(magnitude*8)
		if distance>75:
			continue
		var body = collision.collider
		
		var dmg = 50
		# torso has no joint but we do want it to take damage
		Game.destroy_limb(dmg,body, "torso")
		Game.destroy_limb(dmg,body, "head")
		Game.destroy_limb(dmg,body, "rightairpod")
		Game.destroy_limb(dmg,body, "leftairpod")
		Game.destroy_limb(dmg,body, "bottomleftleg")
		Game.destroy_limb(dmg,body, "topleftleg")
		Game.destroy_limb(dmg,body, "bottomrightleg")
		Game.destroy_limb(dmg,body, "toprightleg")
		Game.destroy_limb(dmg,body, "bottomrightarm")
		Game.destroy_limb(dmg,body, "bottomleftarm")
	
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
