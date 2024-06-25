extends Node2D

@export var line_thickness = 2.8
@export var line_color = Color("ffffff")
func _ready():
	var i= 0
	var between = $RigidBody2D.position - $centerofmass.position
	$RigidBody2D/CollisionPolygon2D.polygon = $RigidBody2D/rigidshapes.polygon
	$RigidBody2D/rigidshapes.color = Color.BLACK
	for position in $RigidBody2D/CollisionPolygon2D.polygon:
		$RigidBody2D/CollisionPolygon2D.polygon[i] += between
		$RigidBody2D/rigidshapes.polygon[i] += between
		i +=1

func _draw():
	var p = Geometry2D.offset_polygon($RigidBody2D/rigidshapes.polygon, -line_thickness)[0]
	draw_polygon(p, [ line_color ])
