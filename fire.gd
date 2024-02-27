extends Node2D


@export var on = true:
	get:
		return on
	set(value):
		on = value
		$Fire.visible = !on
	
func _ready():
	$Fire.play()
	
var previous_time = 0

func _on_area_2d_body_entered(body):
	if !on:
		return
	
	var playsound=false
	if body is CharacterBody2D:
		get_tree().current_scene.kill_player(false)
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
