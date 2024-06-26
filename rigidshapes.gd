extends Node2D

@export var line_thickness = 2.8
@export var line_color = Color("ffffff")
func _ready():
	$RigidBody2D/rigidshapes.color = Color.BLACK

	
	var between = $RigidBody2D.position - $centerofmass.position
	var i= 0
	for position in $RigidBody2D/rigidshapes.polygon:
		$RigidBody2D/rigidshapes.polygon[i] += between
		i +=1
		
	$RigidBody2D/CollisionPolygon2D.polygon = $RigidBody2D/rigidshapes.polygon
	$RigidBody2D/outline.polygon = Geometry2D.offset_polygon($RigidBody2D/rigidshapes.polygon, -line_thickness)[0]

