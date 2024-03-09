extends Node


func _process(delta):
	var newScale =  .04 * sin(3 * (Time.get_unix_time_from_system())) + .5
	$oneoonelives/SplashLabel.scale = Vector2(newScale, newScale)
	
func _physics_process(delta):
	$MouseBox.position=get_viewport().get_mouse_position()
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
	
	

func _on_ragdoll_timer_timeout():
	var ragdoll = load("res://ragdoll.tscn")
	var instance: Node2D = ragdoll.instantiate()
	
	instance.position = Vector2(randi_range(2, 2002), -75)
	var force = 1000
	instance.get_node("torso").apply_impulse(Vector2(randi_range(-force, force), randi_range(-force, force)))
	
	
	add_child(instance)


func _on_options_pressed():
	$OptionsScreen.visible = true
	$TextureRect.z_index = 100


func _on_home_button_pressed():
	$OptionsScreen.visible = false
	$TextureRect.z_index = 0
