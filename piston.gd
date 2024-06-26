extends Powerable

@export var height = 150
@export var animation_duration = 0.1
@export var player_velocity = 1000

@onready var start_pos: Vector2 = $Piston.position

var crushplayer : CharacterBody2D
var crushtime = 0

func _physics_process(delta):
	var ticking=false
	for c in $Piston/crushzone.collision_result:
		if c.collider is CharacterBody2D:
			crushtime+=1
			ticking=true
			if crushtime > 20:
				c.collider.killfromvelocity(Vector2(player_velocity,player_velocity))
	
	if !ticking:
		crushtime -= max(0, crushtime-1)
		
	
func _on_power_changed(new_power):
	if powered == new_power:
		return
	
	powered = new_power

	if powered:
		$PistonOut.play()
		
		for collision in $Piston/ShapeCast2D.collision_result:
			if not collision.collider is CharacterBody2D:
				continue
			
			var r = rotation_degrees/180
			var y_rotation_velocity = player_velocity * cos(PI * r)
			var x_rotation_velocity = player_velocity * sin(PI * r)
			#print(x_rotation_velocity,"  ",y_rotation_velocity)
			
			var character = collision.collider as CharacterBody2D
			character.velocity.y = -y_rotation_velocity
			character.recoil = x_rotation_velocity
	else:
		$PistonIn.play()


	var tween = create_tween()
	
	var new_y =  start_pos.y - height if powered else start_pos.y
	tween.parallel().tween_property($Piston, "position", Vector2(start_pos.x, new_y), animation_duration)
	
	new_y = -.00139 * height if powered else 0
	tween.parallel().tween_property($Spring, "scale", Vector2($Spring.scale.x, new_y), animation_duration)
	
	var finished = func():
		$SafezoneTimer.start()			

	tween.finished.connect(finished)


func _on_safezone_timer_timeout():
	if $Piston/ShapeCast2D.collision_result.is_empty():
		$Piston/CollisionPolygon2D.disabled=false
		$SafezoneTimer.stop()



