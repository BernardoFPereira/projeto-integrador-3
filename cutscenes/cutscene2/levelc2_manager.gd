extends Node

@onready var animation_player = $SelectionAnimationPlayer

var is_finale_selected = false
var finale = ""

func _ready():
	animation_player.play("AmbientShot")
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "AmbientShot":
		animation_player.play("EnterDecision")
	
	elif anim_name == "DecisionLoop":
		if not is_finale_selected:
			animation_player.play("DecisionLoop")
		else:
			if finale == "A":
				animation_player.play("Final_A")
			elif finale == "B":
				animation_player.play("Final_B")
	
	elif anim_name == "Final_A" or anim_name == "Final_B":
		get_tree().change_scene_to_file("res://scenes/interface/main_menu.tscn")

func get_choice(value):
	is_finale_selected = true
	finale = value
	print("Escolha feita: ", value)

func verify_selection():
	if not is_finale_selected:
		pass
	else:
		animation_player.play("DecisionLoop")
