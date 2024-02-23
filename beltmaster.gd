extends Node2D

@export var speed = 200.0
# Called when the node enters the scene tree for the first time.
func _ready():
	updatespeed(speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func updatespeed(speed):
	$beltnoise.pitch_scale =.002*(speed)+.6
	for belt in get_children():
		if not belt is AudioStreamPlayer2D:
			belt.speed = speed
			belt.updatespeed()


func _on_beltnoise_finished():
	$beltnoise.play()
