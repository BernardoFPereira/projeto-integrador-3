extends Node3D
class_name Inspectable

@export var inspect_mesh: PackedScene
@export_multiline var inspect_text: String

@onready var interact_area = $InteractArea
@onready var mesh = $paper

var was_collected := false

func interact():
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.interact_target = null
	player.can_interact = false
	
	var ui = get_tree().get_first_node_in_group("UI")
	ui.show_notification()
	
	interact_area.monitorable = false
	was_collected = true
	player.set_state(player.States.INSPECT)
	#self.visible = false
	
#func _on_interact_area_area_entered(_area):
	#print("Can interact")
	#InspectManager.can_inspect = true
	#InspectManager.inspect_target = self

#func _on_interact_area_area_exited(_area):
	#print("Can NOT interact no mo'")
	#InspectManager.can_inspect = false
	#InspectManager.inspect_target = null
