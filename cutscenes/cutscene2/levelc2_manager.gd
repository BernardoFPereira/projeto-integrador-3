extends Node

@onready var scene_animation_player = $SelectionAnimationPlayer
@onready var char_animation_player = $"padre-cutscene-finale_a/AnimationPlayer"
@onready var cutscene_loop = $"Cutscene-Loop"
@onready var cutscene_scene_a = $"Cutscene-Scene_A"



var is_finale_selected = false
var finale = ""

func _ready():
	scene_animation_player.play("AmbientShot")
	char_animation_player.play("cutscene02-scene01")
	scene_animation_player.animation_finished.connect(_on_animation_finished)
	char_animation_player.animation_finished.connect(_on_animation_finished)
	cutscene_loop.finished.connect(play_loop_audio)

func _on_animation_finished(anim_name):
	if anim_name == "AmbientShot":
		scene_animation_player.play("EnterDecision")
	
	if anim_name == "EnterDecision":
		scene_animation_player.play("DecisionLoop")
		
	
	if anim_name == "DecisionLoop":
		if not is_finale_selected:
			scene_animation_player.play("DecisionLoop")
		else:
			if finale == "A":
				scene_animation_player.play("Finale_A")
				char_animation_player.play("cutscene02-finale_A")
				cutscene_loop.stop()
				cutscene_scene_a.play(0)
			elif finale == "B":
				scene_animation_player.play("Finale_B")
				cutscene_loop.stop()
				#char_animation_player.play("CharFinaleB")
	
	if anim_name == "Finale_A":
		scene_animation_player.play("Finale_A_2")
		char_animation_player.play("cutscene02-finale_a_2")
	
	if anim_name == "Finale_A_2":
		scene_animation_player.play("Credits")
	
	if anim_name == "Credits":
		get_tree().change_scene_to_file("res://cutscenes/cutscene01.tscn")
	
	if anim_name == "Finale_B":
		scene_animation_player.play("Credits")
	
	if anim_name == "cutscene02-scene01":
		char_animation_player.play("cutscene02-loopscene")
	
	if anim_name == "cutscene02-loopscene" and not is_finale_selected:
		char_animation_player.play("cutscene02-loopscene")

	if anim_name == "cutscene02-finale_a_2":
		char_animation_player.play("cutscene02-finale_a_2")

func get_choice(value):
	is_finale_selected = true
	finale = value
	print("Escolha feita: ", value)

func verify_selection():
	if not is_finale_selected:
		scene_animation_player.play("DecisionLoop")
		print("NotSelected")
	else:
		print("Finale Selected")

func play_loop_audio():
	cutscene_loop.play(0)
