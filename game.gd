extends Node

@export var level:Node2D

@export var lives = 101:
	get:
		return lives
	set(value):
		lives = value
		$HUD/Lives.text = str(lives)

func _ready():
	connect_door()

func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		change_level(level.get_node("Door").new_level_id)

	if Input.is_action_just_pressed("Die"):
		kill_player(true)
		
	if Input.is_action_just_pressed("ui_page_up"):
		$Player.position = Vector2($MouseBox.position)
	

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
		
		level.add_child(instance)

func _input(event):
	#print(event)
	pass
	
func _physics_process(delta):
	$MouseBox.position = get_viewport().canvas_transform.affine_inverse() * get_viewport().get_mouse_position()
	
	if $Player.position.y >= 2000:
		kill_player(false)
