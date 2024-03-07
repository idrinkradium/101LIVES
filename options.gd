extends Node

var scrollamount = 100

func _process(delta):
	if Input.is_action_just_released("Zoom Out"):
		$AdvancedOptions.position.y -= scrollamount
	if Input.is_action_just_released("Zoom In"):
		$AdvancedOptions.position.y += scrollamount
	$Options/ADVANCED.rotation_degrees -=.0002


func _on_advanced_pressed():
	$AdvancedOptions.visible = true
	$Options.visible = false
