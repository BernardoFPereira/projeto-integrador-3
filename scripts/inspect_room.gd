extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#inspect_room = get_tree().get_first_node_in_group("InspectRoom")
	InspectManager.inspect_room = self
	InspectManager.inspect_detail = get_tree().get_first_node_in_group("InspectText")
	InspectManager.inspect_text_label = InspectManager.inspect_detail.find_child("InspectText")
	InspectManager.inspect_exit_tip = get_tree().get_first_node_in_group("InspectExitTip")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
