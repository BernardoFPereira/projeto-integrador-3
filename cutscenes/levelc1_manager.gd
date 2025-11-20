extends Node

@onready var animation_player = $SceneAnimationPlayer
@onready var skydome = $skydome
@onready var rotate_speed = 3
@onready var carriage_sfx = $Control/CarriageAndHorses
func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	if GameState.intro_played:
		animation_player.play("EnterLoop")
	else:
		animation_player.play("MainScene")
		carriage_sfx.play(0)
	

func _physics_process(delta):
	skydome.rotation.y = skydome.rotation.y + (rotate_speed / 100)

func _on_animation_finished(anim_name):
	if anim_name == "MainScene":
		animation_player.play("MenuLoop")
	
	if anim_name == "EnterMenu":
		animation_player.play("MenuLoop")
	
	if anim_name == "MenuLoop":
		animation_player.play("MenuLoop")
