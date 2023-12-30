extends Node2D

@export var powerables : Array[Node2D]

var powered = false
var previously_powered = false

func _physics_process(delta): 
	previously_powered = powered
	powered = !$StaticBody2D/ShapeCast2D.collision_result.is_empty()
	
	if previously_powered != powered:
		if powered:
			$PressurePlateIn.play()
		else:
			$PressurePlateOut.play()
		
		await get_tree().create_timer(0.12).timeout
		for powerable in powerables:
			powerable.power_changed.emit(powered)
