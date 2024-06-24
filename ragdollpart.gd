extends Node2D
class_name Limb
var hp = 100
func _process(delta):
	if position.y > 2000 or hp <= 0:
		queue_free()
