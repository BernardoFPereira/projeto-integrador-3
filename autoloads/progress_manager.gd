extends Node

signal first_contact
signal second_contact
signal third_contact

signal first_item_picked
signal second_item_picked
signal third_item_picked

signal game_complete

var past_first_contact := false

var has_item_01 := false
var has_item_02 := false
#var has_item_03 := false
var has_all_items := false

var altar_item_count := 0

var journal: Journal
var page_notes: PageNotes

func _ready() -> void:
	if get_tree().current_scene.name != "MonasteryInside":
		get_tree().root.connect("game_start", _on_game_start)
		return
	journal = get_tree().get_first_node_in_group("UI").find_child("Journal")
	page_notes = get_tree().get_first_node_in_group("UI").find_child("Pages")

func _process(delta) -> void:
	if altar_item_count >= 2:
		emit_signal("game_complete")

func _on_game_start() -> void:
	#journal = get_tree().get_first_node_in_group("UI").find_child("Journal")
	#page_notes = get_tree().get_first_node_in_group("UI").find_child("Pages")
	pass
