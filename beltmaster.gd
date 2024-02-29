class_name BeltMaster extends Node2D

@export var speed = 200.0:
	get:
		return speed
	set(value):
		speed = value
		$beltnoise.pitch_scale =.002*(speed)+.6
		for belt in get_children():
			if belt is Belt:
				belt.get_node("StaticBody2D").constant_linear_velocity.x = speed

