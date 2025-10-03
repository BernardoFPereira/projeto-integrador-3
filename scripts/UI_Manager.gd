extends Control

@onready var journal = $Journal
@onready var menu = $Menu
@onready var settings = $Settings
@onready var pages = $Pages

enum MenuType {
	NONE,
	NOTES,
	PAGES,
	MENU,
	SETTINGS,
}

var menu_type: MenuType = MenuType.NONE;

func clear_menu() -> void:
	journal.visible = false
	menu.visible = false
	settings.visible = false
	pages.visible = false
	
	menu_type = MenuType.NONE

func _on_menu_button_pressed():
	journal.visible = false
	menu.visible = true
	
	menu_type = MenuType.MENU

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/interface/main_menu.tscn")

func _on_notes_button_pressed():
	menu.visible = false
	journal.visible = true
	
	menu_type = MenuType.NOTES

func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	menu.visible = false
	settings.visible = true
	
	menu_type = MenuType.SETTINGS

func _on_settings_back_button_pressed():
	settings.visible = false
	menu.visible = true
	
	menu_type = MenuType.MENU

func _on_pages_button_pressed():
	journal.visible = false
	pages.visible = true
	
	menu_type = MenuType.PAGES

func _on_pages_back_button_pressed():
	pages.visible = false
	journal.visible = true
	
	menu_type = MenuType.NOTES
