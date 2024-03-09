extends Node2D

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
	var parts = find_children("*", "RigidBody2D")
	if parts.is_empty():
		queue_free()
