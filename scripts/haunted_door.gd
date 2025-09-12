extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	ProgressManager.connect("first_contact", _on_first_contact)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		animation_player.play("opened")

func _on_first_contact():
	animation_player.play("open")
