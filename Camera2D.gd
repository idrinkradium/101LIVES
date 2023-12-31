extends Camera2D

var mouse_delta = Vector2()
var n=1
var zoomfactor=0.0
@export var graffiti: TextureRect
func _process(delta):
	#print(n)
	
	if Input.is_action_just_released("Zoom In") and zoomfactor<3:
		zoomfactor+=1
		n = pow(1.5,zoomfactor)
		zoom = Vector2(n, n)
		
	if Input.is_action_just_released("Zoom Out") and zoomfactor>-2:
		zoomfactor-=1
		n = pow(1.5,zoomfactor)
		zoom = Vector2(n, n)
		
	if Input.is_action_pressed("Camera Pan"):
		offset-=mouse_delta/zoom
		graffiti.position+=mouse_delta/zoom/8
	
	
	
		
	mouse_delta = Vector2.ZERO
		
	
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
