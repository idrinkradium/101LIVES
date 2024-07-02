extends Node2D


@onready var on = true:
	get:
		return on
	set(value):
		on = value
		$Area2D/CollisionShape2D.disabled = !on
		$fire.stream_paused = !on
		
		if on: $fireon.play()
		else: $fireoff.play()
		
		var tween = create_tween()
		var new_y = .2 if on else 0
		tween.tween_property($Fire, "scale", Vector2($Fire.scale.x, new_y), .05)
		

var previous_time = 0

func _ready():
	$Fire.play()
	if on:
		$fire.play()

func _on_area_2d_body_entered(body):
	if !on:
		return
	
	var playsound=false
	if body is CharacterBody2D:
		Game.instance.kill_player(false)
		playsound=true
	elif body is RigidBody2D:
		body.queue_free()
		playsound=true
	
	if playsound:
		if Time.get_ticks_msec() - previous_time < 500:
			return
		
		var player = $burned.duplicate()
		var finished = func():
			player.queue_free()
		player.finished.connect(finished)
		add_child(player)
		
		player.play()
		
		previous_time = Time.get_ticks_msec()
