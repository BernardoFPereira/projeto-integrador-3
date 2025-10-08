extends Node

signal first_contact
signal second_contact

var past_first_contact := false

var journal: Journal
var page_notes: PageNotes

func _ready() -> void:
	if get_tree().current_scene.name != "MonasteryInside":
		return
	journal = get_tree().get_first_node_in_group("UI").find_child("Journal")
	page_notes = get_tree().get_first_node_in_group("UI").find_child("Pages")
