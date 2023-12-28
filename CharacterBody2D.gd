extends CharacterBody2D


const SPEED = 400
const JUMP_VELOCITY = -600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D

var previously_on_floor = false

func _physics_process(delta):
	var is_jumping = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_running = not is_zero_approx(velocity.x)
	var is_idling = not is_running and not is_falling

	var prev_velocity = Vector2(velocity) # make a copy

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_jumping:
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
			
			
	if not is_on_floor():
		$Footsteps.stop()
		
	
	if is_idling:
		$Footsteps.stop()
		
		if sprite.animation == "running" or sprite.animation == "run start":
			sprite.play("run stop")
			print("run stop -> play")
	
	if is_running:
		if not $Footsteps.playing and is_on_floor():
			$Footsteps.play()
			
		if sprite.animation == "idle":
			sprite.play("run start")
			print("run start -> play")
	
	if is_jumping:
		sprite.play("Jump")
	

	if not previously_on_floor and is_on_floor():
		sprite.play("impact fall")
		$Thud.play()
		
	
	previously_on_floor = is_on_floor()


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "impact fall":
		sprite.play("idle")
		print('impact fall -> going idle')
		return
		
	if sprite.animation == "run stop":
		sprite.play("idle")
		print('run stop -> idle')
		return
		
	if sprite.animation == "run start":
		sprite.play("running")
		print("running -> play")
		return


func _on_animated_sprite_2d_animation_looped():
	pass
	#if sprite.animation == "run start":
		#sprite.play("running")
		#print('started running animation')
	#elif sprite.animation == "run stop":
		#sprite.play("idle")
		#print('run stop -> idle')
	#elif sprite.animation == "impact fall":
		#sprite.play("idle")
		#print('impact fall -> going idle')


func _on_animated_sprite_2d_animation_changed():
	flip_sprite_direction()
	
	if sprite.animation == "Jump" or sprite.animation == "impact fall":
		sprite.offset.y =-100
	else: sprite.offset.y =0
	
	#if _animated_sprite.animation == "running" or _animated_sprite.animation == "run start":
		#if Input.is_action_pressed("ui_left"):
			#$CollisionPolygon2D.skew = 31
			#$CollisionPolygon2D.position.x = -12
		#else:
			#$CollisionPolygon2D.skew = -31
			#$CollisionPolygon2D.position.x = 12
		#$CollisionPolygon2D.position.y = 7
	#else:
		#$CollisionPolygon2D.skew = 0
		#$CollisionPolygon2D.position.x =  0
		#$CollisionPolygon2D.position.y =  0


func _on_animated_sprite_2d_frame_changed():
	flip_sprite_direction()
		
func flip_sprite_direction():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
