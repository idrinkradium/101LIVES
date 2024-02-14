class_name ClickyButton extends BaseButton

var stream_player = AudioStreamPlayer.new()
var hover = load("res://sounds/buttonhover.mp3")
var click = load("res://sounds/buttonclick.mp3")


func _ready():
	add_child(stream_player)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	pressed.connect(on_clicked)
	pivot_offset = size / 2


func on_mouse_entered():
	# sometimes it freaks out and this function gets spammed
	if stream_player.playing: return
	
	stream_player.stream = hover
	stream_player.pitch_scale = 3
	stream_player.play()
	rotation_degrees = 5
	modulate.v = .85
	

func on_mouse_exited():
	rotation_degrees = 0
	modulate.v = 1
	

func on_clicked():
	stream_player.stream = click
	stream_player.pitch_scale = 1
	stream_player.play()
