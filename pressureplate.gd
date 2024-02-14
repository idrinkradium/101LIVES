extends Node2D

@export var powerables : Array[Node2D]

var powered = false
var previously_powered = false
var tween: Tween
var busy = false

func _physics_process(delta):
	if busy: 
		print(1)
		return
	
	var shapecast = $StaticBody2D/ShapeCast2D
	var valid_collisions = shapecast.collision_result
	
	for collision in shapecast.collision_result:
		if collision.collider == null :#or collision.collider is StaticBody2D:
			#valid_collisions -= 1
			return
			
	
	#if valid_collisions < 1:
	#	return
	
	previously_powered = powered
	powered = !shapecast.collision_result.is_empty()
	
	if previously_powered == powered:
		return
	
	busy = true
	#print(powered, busy)
	#print($ShapeCast2D.collision_result)
	
	if tween:
		tween.kill()
	tween = create_tween()
	
	var animation_duration = 0.1
	
	if powered:
		$PressurePlateIn.play()
		$StaticBody2D/CollisionPolygon2D.polygon[1].y = 25
		$StaticBody2D/CollisionPolygon2D.polygon[2].y = 25
		tween.parallel().tween_property($Sprite2D, "scale", Vector2($Sprite2D.scale.x, 0.1), animation_duration)
		#tween.parallel().tween_property($Sprite2D, "position", Vector2($Sprite2D.position.x,$Sprite2D.position.y + 6), animation_duration)
		#tween.parallel().tween_property($ShapeCast2D, "position", Vector2($ShapeCast2D.position.x, -26), animation_duration)
	else:
		$PressurePlateOut.play()
		tween.parallel().tween_property($Sprite2D, "scale", Vector2($Sprite2D.scale.x, 0.2), animation_duration)
		$StaticBody2D/CollisionPolygon2D.polygon[1].y = -25
		$StaticBody2D/CollisionPolygon2D.polygon[2].y = -25
		#tween.parallel().tween_property($Sprite2D, "position", Vector2($Sprite2D.position.x, $Sprite2D.position.y - 6), animation_duration)
		#tween.parallel().tween_property($ShapeCast2D, "position", Vector2($ShapeCast2D.position.x, -38), animation_duration)
	
	var finished = func():
		busy = false
		
		#await get_tree().create_timer(0.05).timeout
	for powerable in powerables:
		powerable.power_changed.emit(powered)
	
	tween.finished.connect(finished)
	

