extends CharacterBody3D
class_name Player

@export var ui_manager: Control

@onready var view = $View
#@onready var camera = $View/Camera3D
@onready var third_person_camera = $View/SpringArm3D/ThirdPersonCamera
@onready var first_person_camera = $HeadCamerPos/FirstPersonCamera
@onready var head_camer_pos = $HeadCamerPos
@onready var shoulder_camera_pos = $View/ShoulderCameraPos
#@onready var animation_player = $ThePriest/AnimationPlayer
@onready var animation_player = $"ThePriest/Padre-walkF-walkB/AnimationPlayer"
@onready var animation_tree = $"ThePriest/Padre-walkF-walkB/AnimationTree"
@onready var inspect_object_pos = $InspectObjectPos

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

enum CameraModes {
	ThirdPerson,
	FirstPerson,
}

enum States {
	IDLE,
	WALK,
	INSPECT,
	DEAD,
}

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_mode = CameraModes.ThirdPerson
var state = States.IDLE

var inspected_object := false
var is_dragging_mouse := false

var can_interact := false
var interact_target: Node3D

@export var collected_keys: Array[Node3D]
var collected_pages: Array[Node3D]

func _ready():
	set_camera_mode(CameraModes.ThirdPerson)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	if interact_target:
		if global_position.distance_to(interact_target.global_position) > 2:
			print('Interaction Released')
			can_interact = false
			interact_target = null
			
	# handle_camera_pos(delta)
	handle_state(delta)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func _input(event):
	match state:
		States.INSPECT:
			if event is InputEventMouseButton:
				if event.button_index == 1:
					if event.pressed:
						is_dragging_mouse = true
						#print("--- START DRAG ---")
					else:
						is_dragging_mouse = false
						#print("--- STOP DRAG ---")
				
			if event is InputEventMouseMotion and is_dragging_mouse:
				var obj: Node3D = InspectManager.inspect_target
				var inspect_obj: Node3D = obj.get_child(-1)
				
				#print(event.relative)
				
				inspect_obj.rotation.y += event.relative.x * get_process_delta_time()
				inspect_obj.rotation.x += event.relative.y * get_process_delta_time()
			
			if event.is_action_pressed("exit_inspect") and state == States.INSPECT:
				set_state(States.IDLE)
				InspectManager.stop_inspection()
			
		States.DEAD:
			pass
			
		_:
			# DEV POWER -- DISABLE ON BUILD
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				
			if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				var mouse_input = event.relative
				rotate_y(-mouse_input.x * 0.0007)
				view.rotate_x(-mouse_input.y * 0.0007)
				view.rotation.x = clamp(view.rotation.x, deg_to_rad(-55), deg_to_rad(60))
			
			if event.is_action_pressed("interact") and state != States.INSPECT:
				if InspectManager.can_inspect:
					set_state(States.INSPECT)
					return
				
				if interact_target and can_interact:
					interact_target.interact()
			
	if event.is_action_pressed("ui_cancel"):
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
		#States.IDLE:
			#set_camera_mode(CameraModes.ThirdPerson)
		#States.WALK:
			#set_camera_mode(CameraModes.ThirdPerson)
		States.INSPECT:
			set_camera_mode(CameraModes.FirstPerson)
			InspectManager.start_inspection()
		_:
			set_camera_mode(CameraModes.ThirdPerson)
		
	state = new_state

func handle_state(delta) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var blend_value = animation_tree.get("parameters/blend/blend_amount")
	var blend_position = animation_tree.get("parameters/blend_position")
	
	match state:
		States.IDLE:
			blend_position = lerp(blend_position, Vector2.ZERO, delta * 6) 
			animation_tree.set("parameters/blend_position", blend_position)
			if direction:
				set_state(States.WALK)
				
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		
		States.WALK:
			if input_dir.y > 0:
				blend_position = lerp(blend_position, Vector2.UP, delta * 6) 
				animation_tree.set("parameters/blend_position", blend_position)
			elif input_dir.y < 0:
				blend_position = lerp(blend_position, Vector2.DOWN, delta * 6) 
				animation_tree.set("parameters/blend_position", blend_position)
			if !direction:
				set_state(States.IDLE)
				
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		
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
	var area_parent = area.get_parent()
	print(area_parent)
	if area_parent.is_in_group("Door") and !can_interact:
		print("DOOR DETECTEDEBERB")
		can_interact = true
		interact_target = area_parent.get_parent()
		
	if area_parent.is_in_group("Key") and !can_interact:
		print("KEY DETECTEDERBERB")
		can_interact = true
		interact_target = area_parent
