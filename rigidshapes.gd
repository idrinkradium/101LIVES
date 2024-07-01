extends Node2D

@export var line_thickness = 2.8
@export var line_color = Color("ffffff")
func _ready():
	$RigidBody2D/outline.color = Color.BLACK

	
	var between = $RigidBody2D.position - $centerofmass.position
	var i= 0
	for position in $RigidBody2D/outline.polygon:
		$RigidBody2D/outline.polygon[i] += between
		i +=1
		
	$RigidBody2D/CollisionPolygon2D.polygon = $RigidBody2D/outline.polygon
	$RigidBody2D/rigidshapes.polygon = Geometry2D.offset_polygon($RigidBody2D/outline.polygon, -line_thickness)[0]

func _on_rigid_body_2d_body_entered(body):
	if body is CharacterBody2D:
		print($RigidBody2D.linear_velocity)
		if abs($RigidBody2D.linear_velocity.y) or abs($RigidBody2D.linear_velocity.x) > 200:
			await get_tree().create_timer(0.05).timeout
			get_tree().root.get_node("Game").kill_player(true)
