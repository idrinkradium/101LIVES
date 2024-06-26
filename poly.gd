extends Polygon2D


@export var line_thickness = 2.8
@export var line_color = Color("ffffff")

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/CollisionPolygon2D.polygon = polygon
	color = Color.BLACK
	

func _draw():
	var p = Geometry2D.offset_polygon(polygon, -line_thickness)[0]
	draw_polygon(p, [ line_color ])
