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

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		get_tree().current_scene.kill_player(true)
