extends Control

@onready var ui_manager = $".."
@onready var thought_box_text = $Panel/MarginContainer/RichTextLabel

@export_multiline var no_interaction_altar: Array[String]
@export_multiline var found_book: Array[String]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func print_thoughts():
	visible = true
	pass
