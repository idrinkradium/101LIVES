class_name Belt extends Node2D

@export var end = false
@export var flip = false

func _ready():
	if not get_parent() is BeltMaster:
		printerr("parent isnt beltmaster11!1!!!")
		return
	
	$StaticBody2D.constant_linear_velocity.x = get_parent().speed
	$BeltBall.visible = false
	if end:
		$Sprite2D.texture = load("res://objects/conveyorend.png")
		$Sprite2D.flip_h = flip
		$BeltBall.visible = true
		
		var shape = CircleShape2D.new()
		shape.radius = 45
		$StaticBody2D/CollisionShape2D.shape = shape
		$StaticBody2D/CollisionShape2D.position.x -= -50 if flip else 50
		$BeltBall.position.x -= -50 if flip else 50
		
func _process(delta):
	$BeltBall.rotation_degrees+=1.5*(get_parent().speed/100)
