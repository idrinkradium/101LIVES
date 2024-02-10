class_name Powerable extends Node2D

@export var powered = false
var busy = false

signal power_changed(new_power: bool)
