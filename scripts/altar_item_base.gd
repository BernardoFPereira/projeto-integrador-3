extends Node3D

@export var item: Node3D
@export var item_kind: ItemKind

@onready var interact_area = $InteractArea
@onready var audio_player = $AudioStreamPlayer3D

enum ItemKind
{
	WAXING_MOON,
	SPHERE,
	WANING_MOON,
}

func interact():
	var player = get_tree().get_first_node_in_group("Player")
	match item_kind:
		ItemKind.WAXING_MOON:
			if ProgressManager.has_item_01:
				item.visible = true
				interact_area.monitorable = false
				ProgressManager.altar_item_count += 1
				ProgressManager.has_item_01 = false
				audio_player.play()
		ItemKind.SPHERE:
			#if ProgressManager.has_all_items:
				#item.visible = true
				#interact_area.monitorable = false
				#ProgressManager.altar_item_count += 1
			pass
		ItemKind.WANING_MOON:
			if ProgressManager.has_item_02:
				item.visible = true
				interact_area.monitorable = false
				ProgressManager.altar_item_count += 1
				ProgressManager.has_item_02 = false
				audio_player.play()
	
	player.set_state(player.States.PICKUP)
	#item.visible = true
	#interact_area.monitorable = false
