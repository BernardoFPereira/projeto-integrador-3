extends Node

var player: Player
var can_inspect := false
var inspect_target: Node3D
var inspect_target_mesh: Node3D
var inspect_detail: Control
	
var inspect_room: Node3D
var inspect_text_label: Label
var player_og_position: Vector3
#var inspect_room_pos: Vector3

var is_not_pickup := false

func _ready():
	if get_tree().current_scene.name != "MonasteryInside":
		return
		
	player = get_tree().get_first_node_in_group("Player")
	inspect_room = get_tree().get_first_node_in_group("InspectRoom")
	inspect_detail = get_tree().get_first_node_in_group("InspectText")
	inspect_text_label = inspect_detail.find_child("InspectText")

func start_inspection() -> void:
	player_og_position = player.global_position
	player.global_position = inspect_room.global_position
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	inspect_detail.visible = true
	inspect_text_label.text = inspect_target.inspect_text
	
	#if inspect_target.is_in_group("Key"):
		#print("LOOKING AT KEY!")
		#return
	
	inspect_target_mesh = inspect_target.inspect_mesh.instantiate()
	
	inspect_target.mesh.visible = false
	inspect_target.add_child(inspect_target_mesh)
	inspect_target_mesh.global_transform = player.inspect_object_pos.global_transform
	#inspect_target_mesh.scale.x = 0.12
	#inspect_target_mesh.scale.y = 0.12
	#inspect_target_mesh.scale.z = 0.12
	
	can_inspect = false

func stop_inspection() -> void:
	player.global_position = player_og_position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inspect_target.mesh.visible = true
	inspect_target_mesh.queue_free()
	
	inspect_detail.visible = false
	inspect_text_label.text = ""
	
	#if inspect_target.is_in_group("Key"):
		#inspect_target.visible = false
	
	if inspect_target.is_in_group("Page"):
		var page_picked = inspect_target
		player.collected_pages.append(page_picked)
		inspect_target.visible = false
		inspect_target = null
		can_inspect = false
		
		if !is_not_pickup:
			player.ui_manager.pages.reveal_page()
			InspectManager.can_inspect = false
			InspectManager.inspect_target = null
		elif is_not_pickup:
			is_not_pickup = false
	
	can_inspect = true
