extends Node2D
@export var bluetrue = false
@export var sync = 0
@export var portal : Node2D
func _physics_process(delta):
	pass
func _ready():
	if bluetrue == true:
		$Portalblue.visible = true
		$Portalorange.visible =false
	else: 
		$Portalblue.visible = false
		$Portalorange.visible = true
func _on_area_2d_body_entered(body):
	var exitpos = portal.position + Vector2(0,-70)
	
	if body is CharacterBody2D:
		body.velocity = -Vector2(body.velocity)
		body.position = exitpos
	elif body is RigidBody2D:
		var ragdoll = body.get_parent() as Ragdoll
		if ragdoll:
			for limb in ragdoll.get_children():
				if limb is Limb:
					limb.global_transform.origin = exitpos+limb.startpos
					limb.rotation = 0
		else:
			body.linear_velocity = -Vector2(body.linear_velocity)
			body.global_transform.origin = exitpos

static func new_integrate_forces(state):
	print(1)
