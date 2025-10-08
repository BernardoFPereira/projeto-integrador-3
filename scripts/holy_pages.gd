extends Control
class_name PageNotes

@onready var page_01 = $Panel/Page01
@onready var page_02 = $Panel/Page02
@onready var page_03 = $Panel/Page03

var pages: Array[Control] = []

#func reveal_page(page: int) -> void:
	#pages[page].visible = true
	
func reveal_page():
	match len(pages):
		0:
			pages.append(page_01)
			page_01.visible = true
		1:
			pages.append(page_02)
			ProgressManager.emit_signal("second_contact")
			page_02.visible = true
		2:
			pages.append(page_03)
			page_03.visible = true
		_:
			pass
