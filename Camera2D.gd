extends Camera2D

var mouse_delta = Vector2()
var n=1
var zoomfactor=1

func _process(delta):
	if Input.is_action_just_released("Zoom In") and zoomfactor<3:
		zoomfactor+=1
		
	if Input.is_action_just_released("Zoom Out") and zoomfactor>-2:
		zoomfactor-=1
		
	if Input.is_action_pressed("Camera Pan"):
		offset-=mouse_delta/zoom
	mouse_delta = Vector2.ZERO
	
	n = pow(1.5,zoomfactor)
	zoom = Vector2(n, n)
	
	var max = 2000
	offset.x = clamp(offset.x, -max, max)
	max = 500
	offset.y = clamp(offset.y, -max, max)
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
