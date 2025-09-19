extends Control

@onready var journal = $Journal
@onready var menu = $Menu
@onready var settings = $Settings

enum MenuType {
	NONE,
	NOTES,
	MENU,
	SETTINGS,
}

var menu_type: MenuType = MenuType.NONE;

func clear_menu() -> void:
	journal = false
	menu = false
	settings = false
	
	menu_type = MenuType.NONE

func _on_menu_button_pressed():
	menu.visible = true
	journal.visible = false
	
	menu_type = MenuType.MENU
