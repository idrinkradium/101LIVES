extends Node
class_name Game

static var instance : Game
@export var level:Node2D

@export var lives := 101:
	get:
		return lives
	set(value):
		lives = value
		$HUD/Lives.text = str(lives)
		if lives<1:
			$HUD.game_over()

var explosion_charge := 0

func _enter_tree():
	instance=self

func _ready():
	change_level(1)
	
	#😍
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
	
	if level:
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
		if door.requires_power and !door.powered:
			return
		
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
		
	level.get_node("Door").get_node("Area2D").connect("body_entered", on_body_entered)


func kill_player(spawn_ragdoll:bool):
	if lives < 1:
		return
		
	lives -= 1
	
	$Death.play()
	
	# copy of where the player was at the death action
	var prev_player_pos = Vector2($Player.position)
	# offset for how far up we want to put the ragdoll, so feet dont get stuck in the ground
	prev_player_pos.y -= 20
	
	# respawn player at new location (level decides this)
	$Player.position = Vector2(level.get_node("PlayerSpawn").position)
	
	$PoofParticles.position = prev_player_pos
	$PoofParticles.emitting = true
	
	$Player.prev_velocity = Vector2.ZERO
	$Player.velocity = Vector2.ZERO
	
	if spawn_ragdoll:
		# hack, wait some time so physics position of player updates, so the collision boxes aren't inside eachother
		await wait(0.05)
		
		var ragdoll = load("res://ragdoll.tscn")
		var instance = ragdoll.instantiate()
		# spawn ragdoll at death action position
		instance.position = prev_player_pos
		instance.get_node("torso").apply_impulse($Player.velocity * 4)
		
		level.add_child(instance)
	
		return instance
	
var explosion_stream = load("res://sounds/explosion.mp3")

func _physics_process(delta):
	$MouseBox.position = get_viewport().canvas_transform.affine_inverse() * get_viewport().get_mouse_position()
	
	if $Player.position.y >= 2000:
		kill_player(false)
		$Player.velocity=Vector2.ZERO
		
	if Input.is_action_just_pressed("Explode"):
		$MouseBox/ShapeCast2D/ExplosionCircle.modulate = Color.GREEN
		var explosion_circle_tween = create_tween()
		explosion_circle_tween.tween_property($MouseBox/ShapeCast2D/ExplosionCircle, "modulate", Color(1,0,0,.75), .75)
		
	if Input.is_action_pressed("Explode"):
		explosion_charge = clamp(explosion_charge + 1, 0, 100)
	
		$MouseBox/ShapeCast2D.visible=true
		$MouseBox/ShapeCast2D.scale = (Vector2.ONE * explosion_charge) 
		$MouseBox/ExplosionParticles.emitting=false
	
	if Input.is_action_just_released("Explode"):
		var explosion_player = AudioStreamPlayer2D.new()
		$MouseBox.add_child(explosion_player)
		explosion_player.stream = explosion_stream
		explosion_player.finished.connect(explosion_player.queue_free)
		explosion_player.bus = "Explosion"
		explosion_player.pitch_scale = -.0025*(explosion_charge)+1.1
		explosion_player.volume_db =.07*(explosion_charge)-13
		explosion_player.play()
		
		$MouseBox/ExplosionParticles.emitting=true
		
		explosionatshapecast($MouseBox/ShapeCast2D, explosion_charge)
		
		explosion_charge=0
		$MouseBox/ShapeCast2D.visible=false

static func explosionatshapecast(shapecast:ShapeCast2D, power:float):
	for collision in shapecast.collision_result:
		var body = collision.collider as RigidBody2D
		if body == null:
			continue

		var direction=shapecast.global_position.direction_to(body.global_position)
		var distance=shapecast.global_position.distance_to(body.global_position)
		var distancemulti=-.00333*(distance)+1
		var magnitude=direction*distancemulti*power
		body.apply_impulse(magnitude*10)

		if body is Bomb:
			body.explode()
		
		if 'hp' in body:
			var dmg = power * distancemulti
			body.hp -= dmg

static func wait(time:float):
	await instance.get_tree().create_timer(time).timeout

# loop infinitely
func _on_music_finished():
	$Music.play()
