extends Node

var player: Player
var can_inspect := false
var inspect_target: Node3D
var inspect_target_mesh: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
func start_inspection() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
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
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inspect_target.mesh.visible = true
	inspect_target_mesh.queue_free()
	
	#if inspect_target.is_in_group("Key"):
		#inspect_target.visible = false
	
	if inspect_target.is_in_group("Page"):
		inspect_target.visible = false
		inspect_target = null
		can_inspect = false
		
		player.ui_manager.pages.reveal_page()
		InspectManager.can_inspect = false
		InspectManager.inspect_target = null
	
	can_inspect = true
