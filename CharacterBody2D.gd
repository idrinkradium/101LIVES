extends CharacterBody2D


const SPEED = 400
const JUMP_VELOCITY = -600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D

var previously_on_floor = false
var in_water = false
var previously_in_water = false
var is_jumping = false
var is_falling = false
var is_running = false
var is_idling =false

func _physics_process(delta):
	var is_jumping = Input.is_action_just_pressed("ui_accept") and (is_on_floor() or in_water)
	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_running = not is_zero_approx(velocity.x)
	var is_idling = not is_running and not is_falling

	var prev_velocity = Vector2(velocity) # make a copy

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
			
	if in_water and not previously_in_water:
		velocity.y /= 1.18
		sprite.play("Jump")
		

	if is_jumping:
		velocity.y = JUMP_VELOCITY
		if in_water == true:
			velocity.y = JUMP_VELOCITY*1.2
			
		
	
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
	
	if is_running:
		if not $Footsteps.playing and is_on_floor():
			$Footsteps.play()
			
		if sprite.animation == "idle":
			sprite.play("run start")
	
	if is_jumping:
		sprite.play("Jump")
		if not in_water:
			$Jump.play()
		else: 
			$Swim.play()
			

	if not previously_on_floor and is_on_floor() and prev_velocity.y > 300:
		sprite.play("impact fall")
		$Thud.play()
		
	
	previously_on_floor = is_on_floor()


func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "Jump":
		sprite.play("idle")
		return
	
	if sprite.animation == "impact fall":
		sprite.play("idle")
		return
		
	if sprite.animation == "run stop":
		sprite.play("idle")
		return
		
	if sprite.animation == "run start":
		sprite.play("running")
		return


func _on_animated_sprite_2d_animation_changed():
	flip_sprite_direction()
	
	if sprite.animation == "Jump" or sprite.animation == "impact fall":
		sprite.offset.y =-100
	else: sprite.offset.y =0


func _on_animated_sprite_2d_frame_changed():
	flip_sprite_direction()
		
func flip_sprite_direction():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
