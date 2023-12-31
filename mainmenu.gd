extends Node


func _process(delta):
	var newScale =  .04 * sin(3 * (Time.get_unix_time_from_system())) + .5
	$oneoonelives/SplashLabel.scale = Vector2(newScale, newScale)
	
	
	
	
func _physics_process(delta):
	$MouseBox.position=get_viewport().get_mouse_position()
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levelselector.tscn")
	
	

func _on_ragdoll_timer_timeout():
	var ragdoll = load("res://ragdoll.tscn")
	var instance: Node2D = ragdoll.instantiate()
	
	instance.position = Vector2(randi_range(2, 2002), -75)
	var force = 1000
	instance.get_node("torso").apply_impulse(Vector2(randi_range(-force, force), randi_range(-force, force)))
	
	
	add_child(instance)


var play1 = load("res://ui/play1.png")
var play2 = load("res://ui/play2.png")
var options1 = load("res://ui/options1.png")
var options2 = load("res://ui/options2.png")
var levels1 = load("res://ui/levels1.png")
var levels2 = load("res://ui/levels2.png")
var _texture_toggle=true
func _on_timer_timeout():
	_texture_toggle=!_texture_toggle
	if _texture_toggle==true:
		$Play.texture_normal=play1
		$Options.texture_normal=options1
		$Levels.texture_normal=levels1
	else:
		$Play.texture_normal=play2
		$Options.texture_normal=options2
		$Levels.texture_normal=levels2
	
