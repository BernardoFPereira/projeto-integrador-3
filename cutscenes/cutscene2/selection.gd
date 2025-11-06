extends Control

@onready var button_a = $OptionA_Button
@onready var button_b = $OptionB_Button

@onready var cutscene = $".."

func _ready():
	button_a.pressed.connect(_on_button_a_pressed)
	button_b.pressed.connect(_on_button_b_pressed)

func _on_button_a_pressed():
	cutscene.get_choice("A")

func _on_button_b_pressed():
	cutscene.get_choice("B")
