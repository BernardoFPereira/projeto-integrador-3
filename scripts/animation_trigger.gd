extends Node3D

enum TriggerType
{
	ANIMATION,
	SOUND,
	EFFECT,
}

enum ActivationContact
{
	NONE,
	FIRST,
	SECOND,
	THIRD,
	ITEM_ONE,
	ITEM_TWO,
	ITEM_THREE,
}

@export var tg_obj:Node3D
@export var tg_type: TriggerType
@export var activation_contact: ActivationContact

@onready var area_3d = $Area3D

var animationPlayer:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer=tg_obj.find_child("AnimationPlayer")
	activation_contact = activation_contact
	
	area_3d.monitoring = false
	area_3d.monitorable = false
	
	match activation_contact:
		ActivationContact.NONE:
			area_3d.monitoring = true
			area_3d.monitorable = true
		ActivationContact.FIRST:
			ProgressManager.connect("first_contact", _monitorable_on)
		ActivationContact.SECOND:
			ProgressManager.connect("second_contact", _monitorable_on)
		ActivationContact.ITEM_ONE:
			ProgressManager.connect("first_item_picked", _monitorable_on)
			pass
		_:
			pass

func _on_area_3d_body_entered(body):
	match tg_type:
		TriggerType.ANIMATION:
			animationPlayer.play("trigger_animation")
			#set_deferred("monitoring", false)
			#set_deferred("monitorable", false)
			self.queue_free()
		TriggerType.SOUND:
			pass
		TriggerType.EFFECT:
			pass

func _monitorable_on() -> void:
	area_3d.set_deferred("monitoring", true)
	area_3d.set_deferred("monitorable", true)
#
#func _on_second_contact() -> void:
	#set_deferred("monitoring", true)
#
#func _on_first_pickup() -> void:
	#set_deferred("monitoring", true)

