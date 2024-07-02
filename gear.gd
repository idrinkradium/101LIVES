extends Node2D
var churn=true
@export var gear_rotation=45
@export var gamenode: Node2D
func _on_timer_timeout():
	
	$Area2D/CollisionShape2D.disabled=false
	churn=!churn
	var tween=create_tween()
	tween.tween_property(self, "rotation_degrees", gear_rotation, .2).as_relative()
	if churn== true:
		$churn1.play()
	else: $churn2.play()
	var finished = func():
		$Area2D/CollisionShape2D.disabled = true
		

	tween.finished.connect(finished)


func destroy_limb(body,name):
	if body.name == name:
		var ragdoll = body.get_parent()
		var limb = ragdoll.get_node(name)
		var joint = limb.get_node_or_null(name + "joint")
		if joint:
			joint.queue_free()


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		Game.instance.kill_player(true)
		$crunch.play()
	elif body is RigidBody2D:
		destroy_limb(body, "head")
		destroy_limb(body, "rightairpod")
		destroy_limb(body, "leftairpod")
		destroy_limb(body, "bottomleftleg")
		destroy_limb(body, "topleftleg")
		destroy_limb(body, "bottomrightleg")
		destroy_limb(body, "toprightleg")
		destroy_limb(body, "bottomrightarm")
		destroy_limb(body, "bottomleftarm")
