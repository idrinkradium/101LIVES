extends Node2D

@export var end = false
@export var flip = false
@export var speed = 100

func _ready():
	$StaticBody2D.constant_linear_velocity.x = speed
	if end:
		$Sprite2D.texture = load("res://objects/conveyorend.png")
		$Sprite2D.flip_h = flip
		
		var shape = CircleShape2D.new()
		shape.radius = 45
		$StaticBody2D/CollisionShape2D.shape = shape
		$StaticBody2D/CollisionShape2D.position.x -= -50 if flip else 50
