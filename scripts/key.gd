extends Node3D

@onready var mesh = $PH_key2/PH_key
@onready var interact_area = $InteractArea
#
#@export var activation_contact: ActivationContact
#
#enum ActivationContact
#{
	#FIRST,
	#SECOND,
	#THIRD,
#}

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	interact_area.monitorable = false
	visible = false
	ProgressManager.connect("second_contact", _on_second_contact)

func interact() -> void:
	#InspectManager.inspect_target = self
	#InspectManager.inspect_target_mesh = mesh
	#interact_area.monitorable = false
	#player.set_state(player.States.INSPECT)
	player.collected_keys.append(self)
	player.interact_target = null
	player.can_interact = false
	self.visible = false

func _on_second_contact() -> void:
	interact_area.set_deferred("monitorable", true)
	visible = true
	pass
