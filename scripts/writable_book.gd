extends Node3D

@onready var interaction_pos_marker = $InteractionPosMarker

var player: Node3D

func _process(delta):
	if player and player.is_interacting:
		player.global_position = lerp(player.global_position, interaction_pos_marker.global_position, delta * 16)
	pass

func _on_interaction_area_body_entered(body):
	
	if body.is_in_group("Player"):
		if !ProgressManager.past_first_contact:
			ProgressManager.emit_signal("first_contact")
			ProgressManager.past_first_contact = true
			ProgressManager.journal.reveal_note(1)
			
		print("Hit me!")
		#player = body
		#player.is_interacting = true
		#body.go_to_first_person()

func _on_interaction_area_body_exited(body):
		player = null
