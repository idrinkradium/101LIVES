extends Node2D

@export var powerables : Array[Node2D]

var powered = false
var previously_powered = false
var tween: Tween
var busy = false

func _physics_process(delta):
	if busy: 
		return
		 
	previously_powered = powered
	powered = !$ShapeCast2D.collision_result.is_empty()
	
	if previously_powered != powered:
		
		busy = true
		
		if tween:
			tween.kill()
		tween = create_tween()
		
		var animation_duration = 0.1
		if powered:
			$PressurePlateIn.play()
			tween.parallel().tween_property($StaticBody2D, "scale", Vector2($StaticBody2D.scale.x, 0.1), animation_duration)
			tween.parallel().tween_property($StaticBody2D, "position", Vector2($StaticBody2D.position.x, $StaticBody2D.position.y + 6), animation_duration)
			tween.parallel().tween_property($ShapeCast2D, "position", Vector2($ShapeCast2D.position.x, -26), animation_duration)
		else:
			$PressurePlateOut.play()
			tween.parallel().tween_property($StaticBody2D, "scale", Vector2($StaticBody2D.scale.x, 0.2), animation_duration)
			tween.parallel().tween_property($StaticBody2D, "position", Vector2($StaticBody2D.position.x, $StaticBody2D.position.y - 6), animation_duration)
			tween.parallel().tween_property($ShapeCast2D, "position", Vector2($ShapeCast2D.position.x, -38), animation_duration)
		var finished = func():
			busy = false
			
			
		tween.finished.connect(finished)
		
		await get_tree().create_timer(0.12).timeout
		for powerable in powerables:
			powerable.power_changed.emit(powered)
