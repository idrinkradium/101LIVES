extends Node

@export var level:Node

@export var lives = 101:
	get:
		return lives
	set(value):
		lives = value
		$HUD/Lives.text = "{lives}".format({"lives": lives})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		
		var newLevel:PackedScene = load("res://level2.tscn")
		var instance = newLevel.instantiate()
		
		level.queue_free()
		add_child(instance)
		level = instance
		
		$Player.position=Vector2(level.get_node("PlayerSpawn").position)
		$Camera2D.offset = Vector2(level.get_node("CameraSpawn").position)
		
	
	if Input.is_action_just_pressed("Die"):
		kill_player(true)

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
