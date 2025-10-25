extends Camera3D
class_name CameraShake

@export var shake_enabled: bool = false
@export var intensity: float = 0.02
@export var speed: float = 5.0

var _time := 0.0

func _process(delta: float) -> void:
	if not shake_enabled:
		_time = 0.0
		return

	_time += delta * speed
	apply_shake()

func apply_shake() -> void:
	var base_transform = global_transform

	var noise_x = sin(_time * 3.1) * intensity
	var noise_y = cos(_time * 2.7) * intensity
	var offset = Vector3(noise_x, noise_y, 0.0)

	base_transform.origin += offset
	global_transform = base_transform
