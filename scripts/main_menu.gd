extends Control

signal game_start

@onready var first_scene = preload("res://scenes/levels/MonasteryInside.tscn")

@onready var fade_player = $"../Control/Fade/AnimationPlayer"

@onready var main_menu = $MainMenu
@onready var settings = $Settings
@onready var ui_enter = $UI_Enter
@onready var ui_exit = $UI_Exit
@onready var credits = $"../Credits"
@onready var credits_control = $"../Credits/Control"
@onready var credits_animation_player = $"../Credits/Control/CreditsAnimationPlayer"
@onready var thunder_crack = $"../Credits/ThunderCrack"

func _on_play_button_pressed():
	GameState.is_in_menu = false
	ui_enter.play(0)
	fade_player.play("fade_to_game")

	

func _on_settings_button_pressed():
	ui_enter.play(0)
	main_menu.visible = false
	settings.visible = true

func _on_back_button_pressed():
	ui_exit.play(0)
	main_menu.visible = true
	settings.visible = false

func _on_quit_button_pressed():
	ui_exit.play(0)
	get_tree().quit()

func _on_credits_button_pressed():
	main_menu.visible = false
	credits_control.visible = true
	thunder_crack.play(0)
	credits_animation_player.play("Credits_Menu")
	


func _on_fade_to_game_animation_finished(anim_name):
	if anim_name == "fade_to_game":
		get_tree().change_scene_to_packed(first_scene)
	pass # Replace with function body.
