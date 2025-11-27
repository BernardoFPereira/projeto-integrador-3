extends Node

@onready var animation_player = $SceneAnimationPlayer
@onready var skydome = $skydome/skysphere_geo
@onready var rotate_speed = 3
@onready var carriage_sfx = $Control/CarriageAndHorses
@onready var rain = $Control/Rain
@onready var skip_text_button = $Master/SkipTextButton/SkipTextButton
@onready var skip_line_panel = $Master/SkipTextButton/SkipLinePanel
@onready var can_skip = false
@export var rotate_speed_multiplier = -120

func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)
	if GameState.intro_played:
		animation_player.play("EnterMenuLoop")
	else:
		animation_player.play("EnterText")
		

func _physics_process(delta):
	skydome.rotation.y += (rotate_speed * delta) / rotate_speed_multiplier
	print(skydome.rotation.y)

func _on_animation_finished(anim_name):
	if anim_name == "EnterText":
		animation_player.play("TextLoop")
	
	if anim_name == "TextLoop":
		animation_player.play("TextLoop")

	
	if anim_name == "EnterIntro":
		animation_player.play("MenuLoop")
		GameState.intro_played = true
	
	if anim_name == "EnterMenuLoop":
		animation_player.play("MenuLoop")
	
	if anim_name == "MenuLoop":
		animation_player.play("MenuLoop")

func exit_loop():
	animation_player.play("EnterIntro")
	can_skip = false

func allow_skip():
	skip_text_button.button_mask = MOUSE_BUTTON_LEFT
	can_skip = true

func show_skip_line():
	if can_skip:
		skip_line_panel.visible = true

func hide_skip_line():
	skip_line_panel.visible = false
