extends Powerable

@export var new_level_id = 1
@export var requires_power = true


func _on_power_changed(new_power):
	if powered == new_power or !requires_power:
		return
	powered = new_power
	
	#$dorclose.visible = !powered
	$lock.visible = !powered
	
	if powered:
		$unlocked.play()
		#$OpenSfx.play()
	else:
		$locked.play()
		#$CloseSfx.play()
