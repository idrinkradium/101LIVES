extends Node


func _process(delta):
	var newScale =  .3 * sin(2.5 * (Time.get_unix_time_from_system())) + 2
	$SplashLabel.scale = Vector2(newScale, newScale)
	 



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levelselector.tscn")


func _on_ragdoll_timer_timeout():
	var ragdoll = load("res://ragdoll.tscn")
	var instance: Node2D = ragdoll.instantiate()
	
	instance.position = Vector2(randi_range(0, 1000), 0)
	var force = 1000
	instance.get_node("torso").apply_impulse(Vector2(randi_range(-force, force), randi_range(-force, force)))
	
	add_child(instance)
