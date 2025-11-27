extends CharacterBody3D
class_name Player

@export var ui_manager: Control

@onready var camera_fx = $CameraFX
@onready var view = $View
@onready var third_person_camera = $View/SpringArm3D/ThirdPersonCamera
@onready var first_person_camera = $HeadCamerPos/FirstPersonCamera
@onready var head_camer_pos = $HeadCamerPos
@onready var shoulder_camera_pos = $View/ShoulderCameraPos
@onready var animation_player = $ThePriest/GuardNode/Char_Full_Anims/AnimationPlayer
@onready var animation_tree = $ThePriest/GuardNode/Char_Full_Anims/AnimationTree
@onready var inspect_object_pos = $InspectObjectPos
@onready var interact_area = $InteractArea
@onready var footstep_audio_player = $AudioStreamPlayer3D

@export var SPEED = 2.0
@export var max_slope_angle := 45.0
const JUMP_VELOCITY = 4.5

enum CameraModes {
	ThirdPerson,
	FirstPerson,
}

enum States {
	IDLE,
	WALK,
	INSPECT,
	PICKUP,
	CHECK_BOOK,
	THOUGHT,
	DEAD,
}

@export var footstep_audios: Array[AudioStream]

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_mode = CameraModes.ThirdPerson
var state = States.IDLE
var _floor_normal := Vector3.UP

var inspected_object := false
var is_dragging_mouse := false

var can_interact := false
var interact_target: Node3D

@export var collected_keys: Array[Node3D]
@export var collected_pages: Array[Node3D]

var step_distance: float = 1.5
var last_step_pos: float = 0.0
var is_moving: bool = false

func _ready():
	set_camera_mode(CameraModes.ThirdPerson)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if can_interact:
		ui_manager.interact_tip.visible = true
	else:
		ui_manager.interact_tip.visible = false
	
	if state != States.CHECK_BOOK:
		if interact_target:
			if interact_area.global_position.distance_to(interact_target.global_position) > 2:
				print('Interaction Released')
				
				can_interact = false
				interact_target = null
				InspectManager.can_inspect = false
				InspectManager.inspect_target = null
			
	# handle_camera_pos(delta)
	handle_state(delta)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func _input(event):
	match state:
		States.INSPECT:
			if event.is_action_pressed("exit_inspect"):
				InspectManager.stop_inspection()
				set_state(States.IDLE)
			
			#if event is InputEventMouseButton:
				#if event.button_index == 1:
					#if event.pressed:
						#is_dragging_mouse = true
						##print("--- START DRAG ---")
					#else:
						#is_dragging_mouse = false
						#print("--- STOP DRAG ---")
			#if event is InputEventMouseMotion and is_dragging_mouse:
				#var obj: Node3D = InspectManager.inspect_target
				#var inspect_obj: Node3D = obj.get_child(-1)
				#print(event.relative)
				#inspect_obj.rotation.y += event.relative.y * get_process_delta_time()
				#inspect_obj.rotation.x += event.relative.y * get_process_delta_time()
				
		States.DEAD:
			pass
			
		_:
			# DEV POWER -- DISABLE ON BUILD
			#if Input.is_action_just_pressed("ui_accept"):
				#velocity.y = JUMP_VELOCITY
			
			if state != States.CHECK_BOOK:
				if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					var mouse_input = event.relative
					rotate_y(-mouse_input.x * 0.0007)
					view.rotate_x(-mouse_input.y * 0.0007)
					view.rotation.x = clamp(view.rotation.x, deg_to_rad(-30), deg_to_rad(45))
			
			if event.is_action_pressed("interact") and state != States.INSPECT:
				#if InspectManager.can_inspect:
					#set_state(States.INSPECT)
					#return
				
				if interact_target and can_interact:
					#animation_tree.active = false
					#animation_player.play("interacting")
					interact_target.interact()
					
			
			if event.is_action_pressed("ui_cancel"):
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					ui_manager.menu_type = ui_manager.MenuType.MENU
					ui_manager.menu.visible = true
				else:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
					ui_manager.menu_type = ui_manager.MenuType.NONE
					ui_manager.clear_menu()
					
			if event.is_action_pressed("check_notes"):
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
					ui_manager.menu_type = ui_manager.MenuType.NOTES
					ui_manager.journal.visible = true
					
				else:
					Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
					ui_manager.menu_type = ui_manager.MenuType.NONE
					ui_manager.clear_menu()
	

func set_state(new_state: States) -> void:
	match new_state:
		States.IDLE:
			set_camera_mode(CameraModes.ThirdPerson)
		#States.WALK:
			#set_camera_mode(CameraModes.ThirdPerson)
		States.INSPECT:
			set_camera_mode(CameraModes.FirstPerson)
			InspectManager.start_inspection()
		States.PICKUP:
			animation_tree.active = false
			animation_player.play("interacting")
		States.CHECK_BOOK:
			view.rotation = Vector3.ZERO
			animation_tree.active = false
			animation_player.play("check_book")
		_:
			pass
		
	state = new_state

func handle_state(delta) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var blend_value = animation_tree.get("parameters/blend/blend_amount")
	var blend_position = animation_tree.get("parameters/blend_position")
	
	match state:
		States.CHECK_BOOK:
			velocity.x = 0
			velocity.z = 0
			var interact_target_pos = interact_target.interaction_pos_marker.global_position
			var look_target = Vector3(interact_target.global_position.x, global_position.y, interact_target.global_position.z)
			global_position = lerp(global_position, interact_target_pos, delta)
			look_at(look_target)
			
		States.PICKUP:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			pass
			
		States.IDLE:
			if ui_manager.menu_type != ui_manager.MenuType.NONE:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
				blend_position = lerp(blend_position, Vector2.ZERO, delta * 6) 
				animation_tree.set("parameters/blend_position", blend_position)
				return
			
			blend_position = lerp(blend_position, Vector2.ZERO, delta * 6) 
			animation_tree.set("parameters/blend_position", blend_position)
			if direction:
				set_state(States.WALK)
				
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		States.WALK:
			if ui_manager.menu_type != ui_manager.MenuType.NONE:
				#velocity.x = move_toward(velocity.x, 0, SPEED)
				#velocity.z = move_toward(velocity.z, 0, SPEED)
				set_state(States.IDLE)
			
			var speed = velocity.length()
			
			if direction:
				blend_position = lerp(blend_position, input_dir, delta * 6) 
				animation_tree.set("parameters/blend_position", blend_position)
				
				last_step_pos += speed * delta
				if last_step_pos >= step_distance:
					play_footsteps()
					last_step_pos = 0.0
			#if input_dir.y > 0:
				#blend_position = lerp(blend_position, Vector2.UP, delta * 6) 
				#animation_tree.set("parameters/blend_position", blend_position)
			#elif input_dir.y < 0:
				#blend_position = lerp(blend_position, Vector2.DOWN, delta * 6) 
				#animation_tree.set("parameters/blend_position", blend_position)
			if !direction:
				#animation_tree.set("parameters/blend_position", Vector2.ZERO)
				set_state(States.IDLE)
			
			_floor_normal = _get_floor_normal()
			var norm_direction = _project_direction_on_floor(direction)
			velocity.x = norm_direction.x * SPEED
			velocity.z = norm_direction.z * SPEED
		
		States.INSPECT:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
			#blend_value = lerp(blend_value, 0.0, delta * 6) 
			#animation_tree.set("parameters/blend/blend_amount", blend_value)
		
		States.DEAD:
			pass

func set_camera_mode(new_mode: CameraModes) -> void:
	camera_mode = new_mode
	match camera_mode:
		CameraModes.ThirdPerson:
			#third_person_camera.position = shoulder_camera_pos.position
			third_person_camera.current = true
		CameraModes.FirstPerson:
			first_person_camera.current = true

#func handle_camera_pos(delta) -> void:
	#match camera_mode:
		#CameraModes.ThirdPerson:
			#camera.global_position = lerp(camera.global_position, shoulder_camera_pos.global_position, delta)
			#camera.rotation = lerp(camera.rotation, shoulder_camera_pos.rotation, delta * 6)
		#CameraModes.FirstPerson:
			#camera.global_position = lerp(camera.global_position, head_camer_pos.global_position, delta * 6)
			#camera.rotation = lerp(camera.rotation, head_camer_pos.rotation, delta * 6)

func _on_interact_area_area_entered(area):
	ui_manager.interact_tip.visible = true
	var area_parent = area.get_parent()
	
	if area_parent.is_in_group("Item"):
		print("ITEM DETECTEDEBERB")
		can_interact = true
		interact_target = area_parent
		
	if area_parent.is_in_group("AltarItemBase"):
		print("ALTAR BASE DETECTEDEBERB")
		can_interact = true
		interact_target = area_parent
		
	if area_parent.is_in_group("Door") and !can_interact:
		print("DOOR DETECTEDEBERB")
		var door: Door = area_parent.get_parent()
		if door.state == door.DoorState.OPEN:
			return
		can_interact = true
		interact_target = area_parent.get_parent()
		
	if area_parent.is_in_group("Key") and !can_interact:
		print("KEY DETECTEDERBERB")
		can_interact = true
		interact_target = area_parent
		
	if area_parent.is_in_group("Page") and !can_interact:
		print("PAGE DETECTEDERBERB")
		#if interact_target.was_collected:
			#print("Page already collected")
			#return
		can_interact = true
		interact_target = area_parent
		InspectManager.can_inspect = true
		InspectManager.inspect_target = area_parent

func _get_floor_normal() -> Vector3:
	var normal = Vector3.UP
	var count = 0
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_normal().y > 0.7:  # only consider upward-facing surfaces
			normal += col.get_normal()
			count += 1
	
	if count > 0:
		normal /= count
		normal = normal.normalized()
	
	if rad_to_deg(acos(normal.y)) > max_slope_angle:
		return Vector3.UP 
	
	return normal

func _project_direction_on_floor(dir: Vector3) -> Vector3:
	if dir.length() < 0.01:
		return Vector3.ZERO
		
	var plane_normal = _floor_normal
	var projected = dir - plane_normal * dir.dot(plane_normal)
	
	return projected.normalized()

func play_footsteps():
	var rnd_idx = randi_range(0, len(footstep_audios) - 1)
	footstep_audio_player.stream = footstep_audios[rnd_idx]
	footstep_audio_player.play()

#func _on_inspect_area_area_entered(area):
	#var area_parent = area.get_parent()
	#
	#if area_parent.is_in_group("Item"):
		#print("ITEM DETECTEDEBERB")
		#can_interact = true
		#interact_target = area_parent
		#pass
		#
	#if area_parent.is_in_group("ItemBase"):
		#print("ITEM BASE DETECTEDEBERB")
		#can_interact = true
		#interact_target = area_parent
		#pass


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"interacting":
			animation_tree.active = true
			set_state(States.IDLE)
		"check_book":
			animation_tree.active = true
			interact_target = null
			#camera_fx.visible = false
			set_state(States.IDLE)
			camera_fx.fade_out()
			pass
		_:
			pass
