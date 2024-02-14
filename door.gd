extends Powerable

@export var new_level_id = 1
@export var requires_power = true

func _ready():
	$lock.visible = requires_power

func _on_power_changed(new_power):
	if powered == new_power or !requires_power:
		return
		
	powered = new_power
	
	$lock.visible = !powered
	
	if powered:
		$unlocked.play()
	else:
		$locked.play()
