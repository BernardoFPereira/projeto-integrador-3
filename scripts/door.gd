extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var audio_stream = $AudioStream

enum DoorState
{
	OPEN,
	CLOSED,
	LOCKED,
	HAUNTED,
}

@export var state := DoorState.CLOSED
@export var key: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	if state == DoorState.HAUNTED:
		ProgressManager.connect("first_contact", _on_first_contact)

func set_state(new_state):
	state = new_state
	
	match state:
		DoorState.OPEN:
			pass
		DoorState.CLOSED:
			pass
		_:
			audio_stream.play()
			animation_player.play("locked")

func interact(key: Node3D = null):
	match state:
		DoorState.OPEN:
			pass
		DoorState.CLOSED:
			pass
		_:
			audio_stream.play()
			animation_player.play("locked")

func _on_first_contact():
	animation_player.play("open")
	set_state(DoorState.OPEN)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		animation_player.play("opened")
