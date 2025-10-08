@tool
extends Node3D

@onready var light = $Light
@onready var wick = $Wax/Wick

@export var is_on: bool

enum HauntedContact {NONE, HAUNTED_1, HAUNTED_2, HAUNTED_3}
@export var haunted_contact: HauntedContact

func _ready():
	match haunted_contact:
		HauntedContact.HAUNTED_1:
			ProgressManager.connect("first_contact", _on_first_contact)
			pass
		HauntedContact.HAUNTED_2:
			pass
		HauntedContact.HAUNTED_3:
			pass
		_:
			pass

func _process(delta) -> void:
	if is_on:
		light.visible = true
		wick.visible = true
	else:
		light.visible = false
		wick.visible = false

func switch_light(state: bool):
		light.visible = state
		wick.visible = state

func _on_first_contact():
	switch_light(true)
