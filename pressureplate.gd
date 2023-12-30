extends Node2D

@export var powerables : Array[Node2D]

var powered = false
var previously_powered = false

func _physics_process(delta): 
	previously_powered = powered
	powered = !$StaticBody2D/ShapeCast2D.collision_result.is_empty()
	
	if previously_powered != powered:
		var tween = create_tween()
		var animation_duration = 0.1
		if powered:
			$PressurePlateIn.play()
			tween.parallel().tween_property($StaticBody2D, "scale", Vector2($StaticBody2D.scale.x, 0.1), animation_duration)
			tween.parallel().tween_property($StaticBody2D, "position", Vector2($StaticBody2D.position.x, $StaticBody2D.position.y + 6), animation_duration)
		else:
			$PressurePlateOut.play()
			tween.parallel().tween_property($StaticBody2D, "scale", Vector2($StaticBody2D.scale.x, 0.2), animation_duration)
			tween.parallel().tween_property($StaticBody2D, "position", Vector2($StaticBody2D.position.x, $StaticBody2D.position.y - 6), animation_duration)
		
		await get_tree().create_timer(0.12).timeout
		for powerable in powerables:
			powerable.power_changed.emit(powered)
