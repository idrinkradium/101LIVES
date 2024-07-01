extends Polygon2D
@export var line_thickness = 2.8
@export var line_color = Color("ffffff")
@export var ice = false
var on_ice = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D/CollisionPolygon2D.polygon = polygon
	color = Color.BLACK
	if ice == true:
		$StaticBody2D.physics_material_override.friction = .12
		line_color = Color("94EEFF")
		color = Color("A5F1FF")
	

func _draw():
	var p = Geometry2D.offset_polygon(polygon, -line_thickness)[0]
	draw_polygon(p, [ line_color ])
