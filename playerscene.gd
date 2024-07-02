extends CharacterBody2D


var SPEED = 400
const JUMP_VELOCITY = -600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $AnimatedSprite2D
var iceinitvflag = true
var previously_on_floor = false
var poo = 1
var in_water = 0
var is_jumping = false
var is_falling = false
var is_running = false
var is_idling =false
var input_direction = 0
var recoil = 0
var prev_velocity = Vector2.ZERO
var on_ice = false
var icemove_toward = 0
var runflag = false
var iceinitv = 0
var iceexitv = 0
func _physics_process(delta):
	var is_jumping = Input.is_action_just_pressed("w") and (is_on_floor() or in_water>0)
	var is_falling = velocity.y > 0 and not is_on_floor()
	var is_idling = not is_running and not is_falling
	prev_velocity = Vector2(velocity) # make a copy
	if input_direction != 0 and runflag==false:
		is_running=true
		runflag = true
	elif input_direction==0: 
		is_running=false
		runflag = false
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
			
	if in_water==1:   
		velocity.y /= 1.18
	elif in_water==2:
		velocity.y /= 1.4
		
	if is_jumping:
		velocity.y = JUMP_VELOCITY
		if in_water==1:
			velocity.y = JUMP_VELOCITY*1.2
		elif in_water==2:
			velocity.y = JUMP_VELOCITY*.1
	
	input_direction = Input.get_axis("a", "d")
	#if recoil < 1:
	if in_water==2:
		SPEED=100
		$AnimatedSprite2D.speed_scale=.5
		$Footsteps.pitch_scale=.8
	else: 
		SPEED=400
		$AnimatedSprite2D.speed_scale=1
		$Footsteps.pitch_scale=1
	if input_direction:
		velocity.x = input_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#else:
	var recoil_resistance = 100
	if is_falling or is_on_floor():
		recoil_resistance = 1000
	
	recoil = move_toward(recoil, 0, recoil_resistance*delta)  # reduce recoil back to zero recoil_resistance worth of units every frame
	velocity.x += recoil # velocity.x = recoil
	#print(recoil, velocity)
	if on_ice == true:
		if iceinitvflag==true:
			iceinitv = velocity.x
		velocity.y*=.4
		velocity.x = icemove_toward +iceinitv
		if input_direction ==1:
			icemove_toward += 200*delta
		elif input_direction ==-1:
			icemove_toward -= 200*delta
		else: icemove_toward = move_toward(icemove_toward,0,80*delta)
		if icemove_toward < -500:
			icemove_toward = -500
		if icemove_toward > 500:
			icemove_toward = 500
		iceinitv = move_toward(iceinitv, 0, 200*delta)
		iceinitvflag = false
		iceexitv = velocity.x
	if on_ice == false:
		if iceinitvflag == false:
			pass
		icemove_toward = 0
		iceinitv = 0
		iceinitvflag=true
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
		if in_water==0:
			$Jump.play()
		else: 
			$Swim.play()
			
	if not previously_on_floor and is_on_floor() and prev_velocity.y > 300:
		sprite.play("impact fall")
		$Thud.play()
		
		if prev_velocity.abs().y > 1000:
			killfromvelocity(prev_velocity)
			
	if is_falling and (sprite.animation == "running" or sprite.animation == "run start") and input_direction == 0:
		sprite.play("idle")
	
	if prev_velocity.abs().x > 1000 and velocity.abs().x < 10:
		killfromvelocity(prev_velocity)
	
	# this will technically be like 1 frame late but who cares man 💔💝💟💌
	previously_on_floor = is_on_floor()
	
	
func destroy_limb(ragdoll, name, velocity):
	var limb = ragdoll.get_node(name)
	var vy = -velocity.y
	var vx = randi_range(-velocity.y, velocity.y)
	limb.apply_impulse(Vector2(vx,vy)*.3)
	
	var joint = limb.get_node_or_null(name + "joint")
	if joint:
		joint.queue_free()

func killfromvelocity(vel):
	$Grunt.play()
	$Bone.play()
	var ragdoll = await Game.instance.kill_player(true)
	destroy_limb(ragdoll, "head",vel)
	destroy_limb(ragdoll, "rightairpod",vel)
	destroy_limb(ragdoll, "leftairpod",vel)
	destroy_limb(ragdoll, "bottomleftleg",vel)
	destroy_limb(ragdoll, "topleftleg",vel)
	destroy_limb(ragdoll, "bottomrightleg",vel)
	destroy_limb(ragdoll, "toprightleg",vel)
	destroy_limb(ragdoll, "bottomrightarm",vel)
	destroy_limb(ragdoll, "bottomleftarm",vel)

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
	var direction = Input.get_axis("a", "d")
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false


func _on_character_area_body_entered(body):
	if "Poly" in body.get_parent().name and body.get_parent().ice == true:
		on_ice = true

func _on_character_area_body_exited(body):
	if "Poly" in body.get_parent().name and body.get_parent().ice == true:
		on_ice = false
