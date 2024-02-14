extends Node2D

@export var powerables : Array[Node2D]

var powered = false
var previously_powered = false

func _physics_process(delta):
	var shapecast = $StaticBody2D/ShapeCast2D
	
	for collision in shapecast.collision_result:
		if collision.collider == null:
			return
	
	previously_powered = powered
	powered = !shapecast.collision_result.is_empty()
	
	if previously_powered == powered:
		return
	
	var tween = create_tween()
	
	var animation_duration = 0.1
	
	if powered:
		tween.tween_property($Sprite2D, "scale", Vector2($Sprite2D.scale.x, 0.1), animation_duration)
		$StaticBody2D/CollisionPolygon2D.polygon[1].y = 25
		$StaticBody2D/CollisionPolygon2D.polygon[2].y = 25
		$PressurePlateIn.play()
	else:
		tween.tween_property($Sprite2D, "scale", Vector2($Sprite2D.scale.x, 0.2), animation_duration)
		$StaticBody2D/CollisionPolygon2D.polygon[1].y = -25
		$StaticBody2D/CollisionPolygon2D.polygon[2].y = -25
		$PressurePlateOut.play()
	
	var finished = func():
		for powerable in powerables:
			powerable.power_changed.emit(powered)
	
	tween.finished.connect(finished)
	

