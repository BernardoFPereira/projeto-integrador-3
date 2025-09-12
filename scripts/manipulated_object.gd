extends Node3D
class_name Inspectable

@export var inspect_mesh: PackedScene

@onready var mesh = $piece1

func _on_interact_area_area_entered(area):
	#print("Can interact")
	InspectManager.can_inspect = true
	InspectManager.inspect_target = self

func _on_interact_area_area_exited(area):
	#print("Can NOT interact no mo'")
	InspectManager.can_inspect = false
	InspectManager.inspect_target = null
