extends Control

signal game_start

@onready var first_scene = preload("res://scenes/levels/MonasteryInside.tscn")

@onready var main_menu = $MainMenu
@onready var settings = $Settings

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(first_scene)

func _on_settings_button_pressed():
	main_menu.visible = false
	settings.visible = true

func _on_back_button_pressed():
	main_menu.visible = true
	settings.visible = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	main_menu.visible = false
