extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$FireLeft.on = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fire_timer_timeout():
	if $FireLeft.on:
		$FireRight.on = true
		$FireLeft.on = false
	else:
		$FireRight.on = false
		$FireLeft.on = true
	
