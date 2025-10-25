extends Node3D

@export var tg_obj:Node3D
@onready var area_3d = $Area3D

var animationPlayer:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer=tg_obj.find_child("AnimationPlayer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	animationPlayer.play("trigger_animation")
	area_3d.monitoring=false
	pass # Replace with function body.
