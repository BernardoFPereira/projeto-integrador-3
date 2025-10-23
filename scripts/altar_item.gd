extends Node3D

@export_enum("1st", "2nd", "3rd") var item_num = "1st"
@onready var interact_area = $InteractArea

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	print("player registered")
	
func interact():
	match item_num:
		"1st":
			player.has_item_01 = true
		"2nd":
			player.has_item_02 = true
		"3rd":
			player.has_item_03 = true
	self.visible = false
	interact_area.monitorable = false
