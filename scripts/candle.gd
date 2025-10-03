@tool
extends Node3D

@onready var light = $Light
@onready var wick = $Wax/Wick

@export var is_on: bool

func _process(delta) -> void:
	if is_on:
		light.visible = true
		wick.visible = true
	else:
		light.visible = false
		wick.visible = false
