extends Powerable

@export var power = 980

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$StaticBody2D/Area2D.gravity = power
	if powered == true:
		$StaticBody2D/AnimatedSprite2D.play("fan")
	else:
		$StaticBody2D/AnimatedSprite2D.stop()
	$StaticBody2D/Area2D.gravity_direction.x = sin((1.0/180.0)*PI*self.rotation_degrees)
	$StaticBody2D/Area2D.gravity_direction.y = -cos((1.0/180.0)*PI*self.rotation_degrees)
	$StaticBody2D/AnimatedSprite2D.speed_scale = (power/980.0) *2
func _on_power_changed(new_power):
	if powered == new_power:
		return
	
	powered = new_power
	if powered == true:
		$StaticBody2D/AnimatedSprite2D.play("fan")
	else:
		$StaticBody2D/AnimatedSprite2D.stop("fan")
