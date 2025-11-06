extends Node

@onready var animation_player = $SceneAnimationPlayer

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "MainScene":
		get_tree().change_scene_to_file("res://scenes/interface/main_menu.tscn")
