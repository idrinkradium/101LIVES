extends Node2D

var fire_toggle = false
func _ready():
	$FireRight.on = false
	
func _on_fire_timer_timeout():
	fire_toggle = !fire_toggle
	if !$PressurePlateRight.powered:
		$FireRight.on = fire_toggle
	if !$PressurePlateLeft.powered:
		$FireLeft.on = !fire_toggle
	if $PressurePlateLeft.powered and $PressurePlateRight.powered:
		$Door.power_changed.emit(true)
	else: $Door.power_changed.emit(false)

func _on_belt_powerable_power_changed(new_power):
	$BeltMaster.speed = -$BeltMaster.speed
