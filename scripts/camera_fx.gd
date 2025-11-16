extends Control

@onready var animation_player = $AnimationPlayer

func fade_in() -> void:
	animation_player.play("fade")
	pass
	
func fade_out() -> void:
	animation_player.play_backwards("fade")
	pass
