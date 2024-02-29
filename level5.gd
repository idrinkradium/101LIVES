extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$FireLeft.on = false
	
func _on_fire_timer_timeout():
	if $FireLeft.on:
		$FireRight.on = true
		$FireLeft.on = false
	else:
		$FireRight.on = false
		$FireLeft.on = true


func _on_belt_powerable_power_changed(new_power):
	$BeltMaster.speed = -$BeltMaster.speed
