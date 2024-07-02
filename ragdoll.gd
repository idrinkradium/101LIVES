extends Node2D
class_name Ragdoll
func _on_body_entered(body, limb):
	if $Ragpact.playing:
		return
	
	var velocity = get_node(limb).linear_velocity.y

	if velocity < 100:
		return
		
	$Ragpact.volume_db=(velocity/150)-15
	if $Ragpact.volume_db>-7:
		$Ragpact.volume_db=-7.1
	$Ragpact.play()

# check if we have any parts left, if not then remove ourselves
func _on_timer_timeout():
	var limbs = find_children("*", "RigidBody2D")
	if limbs.is_empty():
		queue_free()

func explode(v:Vector2):
	var limbs = find_children("*", "RigidBody2D")
	for limb in limbs:
		var vy = -v.y
		var vx = randi_range(-v.y, v.y)
		limb.apply_impulse(Vector2(vx,vy)*.3)
		if limb.joint:
			limb.joint.queue_free()
