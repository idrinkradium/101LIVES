extends Node

@export var level:Node2D

@export var lives = 101:
	get:
		return lives
	set(value):
		lives = value
		$HUD/Lives.text = str(lives)
		if lives<1:
			$Music.stop()
			$Grunt.play()
			$Trumpet.play()
			var tween = create_tween()
			tween.parallel().tween_property($HUD/Darkness, "modulate", Color(0,0,0,.5), 2)
			tween.parallel().tween_property($"HUD/Game Over", "position", Vector2($"HUD/Game Over".position.x , 180),5  )
			
			var finished = func():
				$HUD/HomeButton.position=Vector2($HUD/HomeButton.position.x, 420)

			tween.finished.connect(finished)
func _ready():
	connect_door()
	$"HUD/Game Over".position.y=-150
	change_level(3)
	
	
func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		change_level(level.get_node("Door").new_level_id)

	if Input.is_action_just_pressed("Die"):
		kill_player(true)
		
	if Input.is_action_just_pressed("ui_page_up"):
		$Player.position = Vector2($MouseBox.position) 
	if Input.is_action_just_pressed("ui_cancel"):
		open_menu()

func open_menu():
	if $HUD/Home.position.y > 0:
		$HUD/Darkness.modulate=(Color(0,0,0,.0))
		$HUD/Home.position.y=-400
		$HUD/Options.position.y=-400
		$HUD/Restart.position.y=-435
	else:
		$HUD/Darkness.modulate=(Color(0,0,0,.5))
		$HUD/Home.position.y=400
		$HUD/Options.position.y=400
		$HUD/Restart.position.y=435

func change_level(id: int):
	var new_level = load("res://level{id}.tscn".format({"id":id}))
	var instance = new_level.instantiate()
	
	level.queue_free()
	add_child(instance)
	level = instance
	
	$Player.position = Vector2(level.get_node("PlayerSpawn").position)
	$Camera2D.offset = Vector2(level.get_node("CameraSpawn").position)
	
	connect_door()
	

func connect_door():
	var on_body_entered = func(body):
		if not body is CharacterBody2D:
			return
		
		var door = level.get_node("Door")
		
		if !door.requires_power:
			$Player.visible = false
			
			door.get_node("OpenSfx").play()
			door.get_node("dorclose").visible = false
			
			var tween = create_tween()
			tween.tween_property($HUD/Darkness, "modulate", Color(0,0,0,1), .5)
			
			var finished = func():
				change_level(door.new_level_id)
				
				$Player.visible = true
				
				tween = create_tween()
				tween.tween_property($HUD/Darkness, "modulate", Color(0,0,0,0), .5)
				
			tween.finished.connect(finished)
	
			return
			
		if door.powered:
			change_level(door.new_level_id)
		
	level.get_node("Door").get_node("Area2D").connect("body_entered", on_body_entered)


func kill_player(spawn_ragdoll:bool):
	lives -= 1
	
	$Death.play()
	
	# copy of where the player was at the death action
	var prev_player_pos = Vector2($Player.position)
	# offset for how far up we want to put the ragdoll, so feet dont get stuck in the ground
	prev_player_pos.y -= 25
	
	# respawn player at new location (level decides this)
	$Player.position = Vector2(level.get_node("PlayerSpawn").position)
	
	$PoofParticles.position = prev_player_pos
	$PoofParticles.emitting = true
	
	# hack, wait some time so physics position of player updates, so the collision boxes aren't inside eachother
	await get_tree().create_timer(0.1).timeout
	
	if spawn_ragdoll:
		var ragdoll = load("res://ragdoll.tscn")
		var instance = ragdoll.instantiate()
		# spawn ragdoll at death action position
		instance.position = prev_player_pos
		instance.get_node("torso").apply_impulse($Player.velocity * 4)
		
		level.add_child(instance)
	
		return instance

func _input(event):
	#print(event)
	pass
	
func _physics_process(delta):
	$MouseBox.position = get_viewport().canvas_transform.affine_inverse() * get_viewport().get_mouse_position()
	
	if $Player.position.y >= 2000:
		kill_player(false)


func _on_mute_music_pressed():
	$Music.stream_paused = !$Music.stream_paused
var home1= load("res://ui/home.png")
var home2= load("res://ui/home2.png")
var menu1= load("res://ui/menu.png")
var menu2= load("res://ui/menu2.png")
var _texture_toggle=true
func _on_anime_time_timeout():
	_texture_toggle=!_texture_toggle
	if _texture_toggle==true:
		$HUD/HomeButton.texture_normal=home1
		$HUD/Menu.texture_normal=menu1
	else:
		$HUD/HomeButton.texture_normal=home2
		$HUD/Menu.texture_normal=menu2


func _on_home_button_pressed():
	get_tree().change_scene_to_file("res://mainmenu.tscn")

var easteregg= load("res://ui/skulleasteregg.png")
func _on_skull_pressed():
	if $HUD/skull.texture_normal == easteregg:
		$HUD/skull.texture_normal = load("res://ui/skull.png")
	else:
		$HUD/skull.texture_normal=easteregg

