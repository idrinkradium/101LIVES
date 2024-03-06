class_name ClickyButton extends TextureButton

var stream_player = AudioStreamPlayer.new()
var hover = load("res://sounds/buttonhover.mp3")
var click = load("res://sounds/buttonclick.mp3")
var animation_timer = Timer.new()
@export var scale_change = 0.03
@export var rotation_change = 5
@export var animation_time = 0.5
@export var darkness = 0.85
@export var texture1 : Texture2D
@export var texture2 : Texture2D

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	pressed.connect(on_clicked)
	
	animation_timer.autostart=true
	animation_timer.wait_time = animation_time
	animation_timer.timeout.connect(on_timeout)
	
	add_child(stream_player)
	add_child(animation_timer)
	stream_player.bus = "Buttons"

func on_mouse_entered():
	# sometimes it freaks out and this function gets spammed because of rotation_degrees
	#if stream_player.playing: return
	
	stream_player.stream = hover
	stream_player.pitch_scale = 3
	stream_player.play()
	rotation_degrees = rotation_change
	scale.x += scale_change
	scale.y += scale_change
	modulate.v = darkness
	

func on_mouse_exited():
	rotation_degrees = 0
	modulate.v = 1
	scale.x -= scale_change
	scale.y -= scale_change
	

func on_clicked():
	stream_player.stream = click
	stream_player.pitch_scale = 1
	stream_player.play()


func on_timeout():
	if texture_normal == texture1:
		texture_normal = texture2
	else:
		texture_normal = texture1
