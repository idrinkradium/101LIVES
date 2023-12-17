extends Label


func _process(delta):
	var newScale =  .3 * sin(2.5 * (Time.get_unix_time_from_system())) + 2
	scale = Vector2(newScale, newScale)
	 


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://levelselector.tscn")
