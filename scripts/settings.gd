extends Control

@onready var resolution_option_button = $ResolutionOptionButton
@onready var ui_enter = $"../UI_Enter"
@onready var ui_exit = $"../UI_Exit"

const RESOLUTIONS_DICTIONARY: Dictionary = {
	"1920x1080": Vector2i(1920, 1080),
	"1600x900": Vector2i(1600, 900),
	"1280x720": Vector2i(1280, 720)
	}

func _ready():
	add_res_items()

func _on_resolution_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTIONS_DICTIONARY.values()[index])

func add_res_items() -> void:
	for resolution_size_text in RESOLUTIONS_DICTIONARY:
		resolution_option_button.add_item(resolution_size_text)

func _on_fullscreen_check_box_toggled(toggled_on):
	if toggled_on:
		ui_enter.play(0)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		ui_exit.play(0)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

