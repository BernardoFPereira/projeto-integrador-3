extends Control
class_name CamFX

@onready var animation_player = $AnimationPlayer
@onready var player = $".."
@onready var is_end_game = false

func fade_in(is_end: bool) -> void:
	animation_player.play("fade")
	if is_end:
		is_end_game = true
	
func fade_out() -> void:
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fade":
			if is_end_game:
				get_tree().change_scene_to_file("res://cutscenes/cutscene2/cutscene02.tscn")

