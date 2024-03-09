extends Node2D

func _process(delta):
	if position.y > 2000:
		queue_free()
