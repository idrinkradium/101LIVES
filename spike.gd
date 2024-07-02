extends Node2D


func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		Game.instance.kill_player(true)
		$stab.play()
