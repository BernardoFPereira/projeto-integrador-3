extends OmniLight3D

var player
var default_energy
var default_light_pos

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	default_energy = light_energy
	default_light_pos = global_position
	
func _process(delta):
	if global_position.distance_to(player.global_position) < 4:
		light_energy = lerp(light_energy, 0.0, delta * 2)
	else:
		light_energy = lerp(light_energy, default_energy, delta)
