extends Node2D
class_name Limb
var hp = 100:
	get:
		return hp
	set(value):
		hp=value
		modulate.v=(hp * .003) + 0.7
		
		
@export var destroyparticles : CPUParticles2D
func _process(delta):
	if position.y > 2000 or hp <= 0:
		var p : CPUParticles2D= destroyparticles.duplicate()
		p.emitting=true
		p.position = global_position
		# make sure to delete particle node after finish
		p.finished.connect(func(): p.queue_free())
		get_tree().root.get_node("Game").add_child(p)
		
		# delet
		queue_free()
