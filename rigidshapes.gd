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

