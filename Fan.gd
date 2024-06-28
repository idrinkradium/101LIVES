extends Powerable



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if powered == true:
		$StaticBody2D/AnimatedSprite2D.play("fan")
	else:
		$StaticBody2D/AnimatedSprite2D.stop("fan")

func _on_power_changed(new_power):
	if powered == new_power:
		return
	
	powered = new_power
	if powered == true:
		$AnimatedSprite2D.play("fan")
	else:
		$AnimatedSprite2D.stop("fan")
