extends Slider

@export var bus : String

func _ready():
	max_value = 1.0
	step = 0.01
	value = 1

func _value_changed(new_value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), linear_to_db(new_value))
