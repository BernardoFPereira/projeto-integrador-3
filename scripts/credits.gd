extends Node

@onready var credits_animation_player = $Control/CreditsAnimationPlayer 
@onready var scene_animation_player = $"../SceneAnimationPlayer"

@onready var next_credit_button = $Control/NextCreditButton
@onready var prev_credit_button = $Control/PrevCreditButton
@onready var back_button = $Control/BackButton
@onready var control_1 = $Control/Control1
@onready var control_2 = $Control/Control2
@onready var control_3 = $Control/Control3


@onready var credits_min_page = 1
@onready var credits_max_page = 3
@onready var credits_current_page = 1

func _ready():
	if GameState.is_in_main_menu:
		credits_animation_player.play("Credits_Menu")
	else:
		credits_animation_player.play("Credits_From_Finale")

func check_next_credits_page():
	if credits_current_page == 1:
		prev_credit_button.disabled = false
		control_1.visible = false
		control_2.visible = true
		credits_current_page = clampi(credits_current_page + 1, credits_min_page, credits_max_page)
		
	elif credits_current_page == 2:
		next_credit_button.disabled = true
		control_2.visible = false
		control_3.visible = true
		credits_current_page = clampi(credits_current_page + 1, credits_min_page, credits_max_page)

func check_prev_credits_page():
	if credits_current_page == 3:
		next_credit_button.disabled = true
		control_3.visible = false
		control_2.visible = true
		credits_current_page = clampi(credits_current_page - 1, credits_min_page, credits_max_page)
		
	elif credits_current_page == 2:
		prev_credit_button.disabled = true
		control_2.visible = false
		control_1.visible = true
		credits_current_page = clampi(credits_current_page - 1, credits_min_page, credits_max_page)



func _on_back_button_pressed():
	credits_animation_player.play("Exit_Credits")
	scene_animation_player.play("EnterMenuLoop")
