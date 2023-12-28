extends Node2D

var animating = false
var bruh = false
var launch_body = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#print(bruh)
	
	if Input.is_action_just_pressed("ui_down"):
		animating = true
		bruh = true
		
	if animating:
		var y = 1.75 * delta
		$Spring.scale.y -= y
		$Piston.position.y -= 1200*delta #1260
		
		if $Spring.scale.y <= -0.22:
			animating = false
			
	if Input.is_action_just_pressed("ui_home"):
		$Spring.scale.y = 0
		$Piston.position.y = -20
	
	if bruh and launch_body != null:
		print(launch_body)
		if launch_body is CharacterBody2D:
			launch_body.velocity.y = -1000
		elif launch_body is RigidBody2D:
			
			for child in launch_body.get_parent().get_children():
				if child is RigidBody2D:
					child.apply_impulse(Vector2(0, -2500))
					#child.apply_force(Vector2(0, -2500))
			
		bruh = false




func _on_area_2d_body_entered(body):
	launch_body = body
		

func _on_area_2d_body_exited(body):
	launch_body = null
