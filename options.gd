extends Node

var scrollamount = 100

func _process(delta):
	if Input.is_action_just_released("Zoom Out"):
		$AdvancedOptions.position.y -= scrollamount
	if Input.is_action_just_released("Zoom In"):
		$AdvancedOptions.position.y += scrollamount
	$Options/ADVANCED.rotation_degrees -=.0002

func open():
	$AdvancedOptions.visible = false
	$Options.visible = true

func _on_advanced_pressed():
	$AdvancedOptions.visible = true
	$Options.visible = false

func _on_h_slider_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), linear_to_db(value))

func _on_h_slider_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
