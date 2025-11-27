extends Node

@onready var credits_animation_player = $CreditsAnimationPlayer


func _ready():
	credits_animation_player.play("Credits")
	credits_animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "Credits":
		get_tree().change_scene_to_file("res://cutscenes/cutscene01.tscn")
