extends Camera2D

var mouse_delta = Vector2()
var n=1
var zoomfactor=0.0

func _process(delta):
	
	#print(n)
	if Input.is_action_just_released("Zoom In"):
		zoomfactor+=1
		n = pow(1.5,zoomfactor)
		zoom = Vector2(n, n)
		
		print(zoom)
		
	if Input.is_action_just_released("Zoom Out"):
		zoomfactor-=1
		n = pow(1.5,zoomfactor)
		zoom = Vector2(n, n)
		print(zoom)
		
	if Input.is_action_pressed("Camera Pan"):
		offset-=mouse_delta/zoom
		
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
