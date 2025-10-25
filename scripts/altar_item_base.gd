extends Node3D

@export var item: Node3D
@onready var interact_area = $InteractArea

func interact():
	#var player = get_tree().get_first_node_in_group("Player")
	item.visible = true
	interact_area.monitorable = false
