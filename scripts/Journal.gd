extends Control
class_name Journal

@onready var ui = $".."
@onready var note_1: RichTextLabel = $Panel/Note1
@onready var note_2: RichTextLabel = $Panel/Note2
@onready var note_3: RichTextLabel = $Panel/Note3

var notes: Array[RichTextLabel]

func _ready():
	notes = [note_1, note_2, note_3]

func reveal_note(note: int) -> void:
	notes[note].visible = true
	ui.show_notification()

func _on_menu_button_pressed():
	pass # Replace with function body.
