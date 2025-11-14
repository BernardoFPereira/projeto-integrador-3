extends Control

@onready var journal = $Journal
@onready var menu = $Menu
@onready var settings = $Settings
@onready var pages = $Pages
@onready var interact_tip = $InteractTip
@onready var inspect_text = $InspectDetailText
@onready var exit_inspect_tip = $ExitInspectTip

# TEMPORARY NODE
@onready var temp_end = $Temp_End

enum MenuType {
	NONE,
	NOTES,
	PAGES,
	MENU,
	SETTINGS,
}

var menu_type: MenuType = MenuType.NONE;

func _ready():
	ProgressManager.connect("game_complete", _on_altar_complete)
	ProgressManager.journal = journal
	ProgressManager.page_notes = pages

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


func _on_inspect_button_01_pressed():
	var player = get_tree().get_first_node_in_group("Player")
	
	if len(player.collected_pages) > 0:
		InspectManager.inspect_target = player.collected_pages[0]
		InspectManager.inspect_target.visible = true
		InspectManager.is_not_pickup = true
		
		player.set_state(player.States.INSPECT)
		pages.visible = false
		menu_type = MenuType.NONE
	
func _on_inspect_button_02_pressed():
	var player = get_tree().get_first_node_in_group("Player")
	
	if len(player.collected_pages) > 1:
		InspectManager.inspect_target = player.collected_pages[1]
		InspectManager.inspect_target.visible = true
		InspectManager.is_not_pickup = true
		
		player.set_state(player.States.INSPECT)
		pages.visible = false
		menu_type = MenuType.NONE

func _on_inspect_button_03_pressed():
	var player = get_tree().get_first_node_in_group("Player")
	
	if len(player.collected_pages) > 2:
		InspectManager.inspect_target = player.collected_pages[2]
		InspectManager.inspect_target.visible = true
		InspectManager.is_not_pickup = true
	
		player.set_state(player.States.INSPECT)
		pages.visible = false
		menu_type = MenuType.NONE
		
func _on_altar_complete() -> void:
	temp_end.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
