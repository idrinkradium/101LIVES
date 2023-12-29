extends Node2D

@export var powerables : Array[Node2D]

var powered = false
var previously_powered = false

func _physics_process(delta): 
	previously_powered = powered
	powered = !$StaticBody2D/ShapeCast2D.collision_result.is_empty()
	
	if previously_powered != powered:
		for powerable in powerables:
			powerable.power_changed.emit(powered)
