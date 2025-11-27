extends Control

@export var audio_clips: Array[AudioStream]

@onready var audio_stream_player = $"../AudioStreamPlayer"

func pick_n_play() -> void:
	var rand_idx = randi_range(0, len(audio_clips) - 1)
	audio_stream_player.stream = audio_clips[rand_idx]
	audio_stream_player.play()
