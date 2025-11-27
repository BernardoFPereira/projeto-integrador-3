extends Control

@onready var ui_enter = $"../../UI_Enter"
@onready var ui_exit = $"../../UI_Exit"

@export var audio_bus_name:String
var audio_bus_id
var db


func _ready():
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)


func _on_master_slider_value_changed(value):
	db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)


func _on_sfx_slider_value_changed(value):
	db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)


func _on_music_slider_value_changed(value):
	db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)


func _on_ui_slider_value_changed(value):
	db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)

func _on_cutscenes_slider_value_changed(value):
	db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)


func _on_drag_started():
	ui_enter.play(0)


func _on_drag_ended(value_changed):
	ui_exit.play(0)

