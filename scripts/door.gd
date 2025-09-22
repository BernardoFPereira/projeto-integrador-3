extends Node3D

@onready var locked_audio = $DoorMesh/LockedAudio
@onready var open_audio = $DoorMesh/OpenAudio
@onready var animation_player = $AnimationPlayer

@export var state := DoorState.CLOSED
@export var key: Node3D

enum DoorState
{
	OPEN,
	CLOSED,
	LOCKED,
	HAUNTED,
}

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
	if state == DoorState.HAUNTED:
		ProgressManager.connect("first_contact", _on_first_contact)

func set_state(new_state):
	state = new_state
	#
	#match state:
		#DoorState.OPEN:
			#pass
		#DoorState.CLOSED:
			#pass
		#_:
			#locked_audio.play()
			#animation_player.play("locked")

func interact():
	match state:
		DoorState.OPEN:
			pass
		DoorState.CLOSED:
			open_audio.play()
			animation_player.play("open")
			
		DoorState.LOCKED:
			#for k in player.collected_keys:
				#print("collected key 1: %s" % k)
				#print("Door key: %s" % key)
				
			if key in player.collected_keys:
				animation_player.play("open")
				set_state(DoorState.OPEN)
				print("DOOR UNLOCKED!")
				return
				
			locked_audio.play()
			animation_player.play("locked")
			
		DoorState.HAUNTED:
			locked_audio.play()
			animation_player.play("locked")
			
		_:
			pass

func _on_first_contact():
	animation_player.play("open")
	set_state(DoorState.OPEN)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		animation_player.play("opened")
