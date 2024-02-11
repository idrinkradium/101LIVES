extends CharacterBody2D


const SPEED = 400
const JUMP_VELOCITY = -600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D

var previously_on_floor = false

var in_water = false
var is_jumping = false
var is_falling = false
var is_running = false
var is_idling =false
var input_direction = 0
var stoptime=0

func _physics_process(delta):
	var is_jumping = Input.is_action_just_pressed("ui_accept") and (is_on_floor() or in_water)
	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_running = not is_zero_approx(velocity.x)
	var is_idling = not is_running and not is_falling

	var prev_velocity = Vector2(velocity) # make a copy

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
			
	if in_water:
		velocity.y /= 1.18
		
	if is_jumping:
		velocity.y = JUMP_VELOCITY
		if in_water == true:
			velocity.y = JUMP_VELOCITY*1.2
			
	input_direction = Input.get_axis("ui_left", "ui_right")
	if input_direction:
		velocity.x = input_direction * SPEED
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
		
		if sprite.animation == "idle" or sprite.animation == "run stop" or sprite.animation == "impact fall":
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
		
		if prev_velocity.y > 1000:
			$Grunt.play()
			$Bone.play()
			var ragdoll = await get_tree().current_scene.kill_player(true)
			destroy_limb(ragdoll, "head",prev_velocity)
			destroy_limb(ragdoll, "rightairpod",prev_velocity)
			destroy_limb(ragdoll, "leftairpod",prev_velocity)
			destroy_limb(ragdoll, "bottomleftleg",prev_velocity)
			destroy_limb(ragdoll, "topleftleg",prev_velocity)
			destroy_limb(ragdoll, "bottomrightleg",prev_velocity)
			destroy_limb(ragdoll, "toprightleg",prev_velocity)
			destroy_limb(ragdoll, "bottomrightarm",prev_velocity)
			destroy_limb(ragdoll, "bottomleftarm",prev_velocity)
			
	if is_falling and (sprite.animation == "running" or sprite.animation == "run start") and input_direction == 0:
		sprite.play("idle")
	
	previously_on_floor = is_on_floor()

func destroy_limb(ragdoll, name, velocity):
	var limb = ragdoll.get_node(name)
	var vy = -velocity.y
	var vx = randi_range(-velocity.y, velocity.y)
	limb.apply_impulse(Vector2(vx,vy)*.3)
	
	var joint = limb.get_node_or_null(name + "joint")
	if joint:
		joint.queue_free()
					
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
