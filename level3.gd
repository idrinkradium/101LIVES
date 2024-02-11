extends Node2D

@onready var bottom_start_pos: Vector2 = $BottomSpikes.position
@onready var top_start_pos: Vector2 = $TopSpikes.position

func yeah(retractor, spikes, new_power, start_pos, bruh):
	if retractor.powered == new_power or retractor.busy:
		return
	
	retractor.powered = new_power
	retractor.busy = true
	
	var tween = create_tween()
	
	var animation_duration = 0.3
	var height = 66
	if bruh:
		height = -height
	
	var new_y = start_pos.y - height if retractor.powered else start_pos.y
	
	tween.parallel().tween_property(spikes, "position", Vector2(start_pos.x, new_y), animation_duration)
	$BottomSpikes/retract1.play()
		
	var finished = func():
		retractor.busy = false
	tween.finished.connect(finished)
	
	if $BottomSpikeRetractor.powered and $TopSpikeRetractor.powered:
		$Door.power_changed.emit(true)
	else:
		$Door.power_changed.emit(false)
		
func _on_spike_retractor_power_changed(new_power):
	yeah($BottomSpikeRetractor, $BottomSpikes, new_power, bottom_start_pos, true)
	

func _on_top_spike_retractor_power_changed(new_power):
	yeah($TopSpikeRetractor, $TopSpikes, new_power, top_start_pos, false)


func _process(delta):
	if $BottomSpikeRetractor.powered and $TopSpikeRetractor.powered:
		$roast2.modulate.a = 0
		$roast2.should_fade=false
	else: $roast2.should_fade=true
