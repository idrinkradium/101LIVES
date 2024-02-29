extends CanvasLayer

var opened_menu = null

func open_menu():
	if get_parent().lives < 1: 
		return
	
	if !opened_menu:
		$PauseMenu.visible = true
		$Darkness.modulate=Color(0,0,0,0.5)
		get_tree().paused = true
		opened_menu = $PauseMenu
	else:
		$PauseMenu.visible = false
		$Darkness.modulate=Color(0,0,0,0)
		get_tree().paused = false
		opened_menu = null

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		open_menu()
	$Options/ADVANCED.rotation_degrees -=.0002
func game_over():
	$"../Music".stop()
	$"../Grunt".play()
	$"../Trumpet".play()
	var tween = create_tween()
	tween.parallel().tween_property($Darkness, "modulate", Color(0,0,0,.5), 2)
	tween.parallel().tween_property($"Game Over", "position", Vector2($"Game Over".position.x , 180),5  )
	
	var finished = func():
		$HomeButton.position=Vector2($HomeButton.position.x, 420)

	tween.finished.connect(finished)

func _on_home_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mainmenu.tscn")

var easteregg= load("res://ui/skulleasteregg.png")
var skull = load("res://ui/skull.png")
func _on_skull_pressed():
	$"../Quack".play()
	if $skull.texture_normal == easteregg:
		$skull.texture_normal = skull
	else:
		$skull.texture_normal=easteregg

func _on_cheat_text_submitted(new_text):
	if new_text.is_valid_int():
		get_parent().change_level(int(new_text))

func _on_options_pressed():
	pass
	#var options = load("res://options.tscn").instantiate()
	#$HUD.add_child(options)
