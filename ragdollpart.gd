extends Node2D
class_name Limb
var hp = 100
@export var destroyparticles : CPUParticles2D
func _process(delta):
	if position.y > 2000 or hp <= 0:
		var p = destroyparticles.duplicate()
		p.emitting=true
		p.position = global_position
		get_tree().root.get_node("Game").add_child(p)
		
		# delet
		queue_free()
