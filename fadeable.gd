class_name Fadable extends Node2D

var time = 0
var should_fade = true
@export var distance_object = self 
@export var far= 200.0
@export var spread=20.0
@export var wait = 0
var wait_time = 0.0
@export var wait_distance = 500
@onready var player =  get_tree().current_scene.get_node("Player")

func _ready():
	modulate.a = 0
	
func _process(delta):
	if !should_fade:
		return

	var distance = abs(player.position.x - distance_object.position.x)
	
	if wait > 0 and wait_distance > distance:
		return
	
	if wait_distance < distance:
		wait_time += delta
	
	if distance < far:
		modulate.a = 1
	else:
		modulate.a = (-spread/100000)*((distance-far)**2)+1

