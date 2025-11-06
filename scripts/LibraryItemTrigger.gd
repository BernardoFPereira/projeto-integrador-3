extends Node

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	ProgressManager.connect("first_item_picked", _start_animation)

func _start_animation() -> void:
	animation_player.play("FallReveal")
