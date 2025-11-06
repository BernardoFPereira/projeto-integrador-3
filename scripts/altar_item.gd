extends Node3D

@export var item_order: ItemOrder

@onready var interact_area = $InteractArea

enum ItemOrder
{
	FIRST,
	SECOND,
	THIRD,
}

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	item_order = item_order
	#print("player registered")
	#
	#match item_order:
		#ItemOrder.FIRST:
			#ProgressManager.connect("first_item_picked", _on_first_pick)
			#pass
		#ItemOrder.SECOND:
			#passw
		#ItemOrder.THIRD:
			#pass
	
func interact():
	match item_order:
		ItemOrder.FIRST:
			ProgressManager.emit_signal("first_item_picked")
			ProgressManager.has_item_01 = true
		ItemOrder.SECOND:
			ProgressManager.has_item_02 = true
			#ProgressManager.has_item_02 = true
			#pass
		ItemOrder.THIRD:
			#ProgressManager.has_item_03 = true
			#ProgressManager.has_all_items = true
			pass
		
	self.visible = false
	interact_area.monitorable = false

#func _on_first_pick() -> void:
	#pass
