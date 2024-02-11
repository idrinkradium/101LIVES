extends Node2D

var wspx = -64
var water1_sp = Vector2(wspx, 768)
var water2_sp = Vector2(wspx, 270)
var busy = false

var tween :Tween

func yeah(retractor, new_power):
	if retractor.powered == new_power:
		return
	
	retractor.powered = new_power
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	var animation_duration =1.5
	
	var start_pos = water1_sp
	var height = water1_sp.y
	if $WaterLevel1.powered and !$WaterLevel2.powered:
		height = water2_sp.y
	elif !$WaterLevel1.powered and $WaterLevel2.powered:
		height = water2_sp.y
		start_pos = water1_sp
	elif $WaterLevel1.powered and $WaterLevel2.powered:
		height = 0
		start_pos = water2_sp
	 
	if retractor.powered:
		$Water_Body/WaterUp.play()
	else:
		$Water_Body/WaterDown.play()
		
	var new_y = start_pos.y - height if retractor.powered else start_pos.y
	
	tween.parallel().tween_property($Water_Body, "position", Vector2(start_pos.x, new_y), animation_duration)


func _on_water_level_1_power_changed(new_power):
	yeah($WaterLevel1, new_power)


func _on_water_level_2_power_changed(new_power):
	yeah($WaterLevel2, new_power)
