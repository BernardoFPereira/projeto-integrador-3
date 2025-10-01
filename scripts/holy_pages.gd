extends Control

@onready var page_01 = $Panel/Page01
@onready var page_02 = $Panel/Page02
@onready var page_03 = $Panel/Page03

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_first_page_found():
	page_01.visible = true

func _on_second_page_found():
	page_02.visible = true

func _on_third_page_found():
	page_03.visible = true
