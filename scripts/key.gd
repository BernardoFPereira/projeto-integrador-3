extends Node3D

@export var matching_door: Node3D

@onready var mesh = $PH_key2/PH_key
@onready var interact_area = $InteractArea

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func interact() -> void:
	#InspectManager.inspect_target = self
	#InspectManager.inspect_target_mesh = mesh
	#player.set_state(player.States.INSPECT)
	player.collected_keys.append(self)
	player.interact_target = null
	player.can_interact = false
	self.visible = false
	interact_area.monitorable = false
