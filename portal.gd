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
	if body is CharacterBody2D:
		body.velocity = -Vector2(body.velocity)
		body.position = portal.position + Vector2(0,-70)
		#print(body.velocity)
	if body is RigidBody2D:
		print("awdasd")
		body.position = portal.position + Vector2(0,-200)
		body.linear_velocity = -Vector2(body.linear_velocity)
		print(body.linear_velocity)
		#print(body)
