extends Control

@onready var resolution = $ResolutionOptionButton
@onready var fullscreen = $FullscreenCheckBox
@onready var slider_master = $MasterSlider
@onready var slider_music = $SFXSlider
@onready var slider_sfx = $MusicSlider

var available_resolutions = [
	Vector2i(1920,1080),
	Vector2i(1280,720)
]

func _ready():
	Settings.load()

	for r in available_resolutions:
		resolution.add_item(str(r.x) + "x" + str(r.y))

	resolution.select(available_resolutions.find(Settings.resolution))
	fullscreen.button_pressed = Settings.fullscreen
	slider_master.value = Settings.volume_master * 100
	slider_music.value = Settings.volume_music * 100
	slider_sfx.value = Settings.volume_sfx * 100

	apply_video_settings()
	apply_audio_settings()

func _on_resolution_option_button_item_selected(index):
	Settings.resolution = available_resolutions[index]
	apply_video_settings()
	Settings.save()

func _on_fullscreen_check_box_toggled(toggled_on):
	Settings.fullscreen = true
	apply_video_settings()
	Settings.save()

func apply_video_settings():
	if Settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Settings.resolution)

func _on_master_slider_value_changed(value):
	Settings.volume_master = value / 100.0
	apply_audio_settings()
	Settings.save()

func _on_music_slider_value_changed(value):
	Settings.volume_music = value / 100.0
	apply_audio_settings()
	Settings.save()

func _on_sfx_slider_value_changed(value):
	Settings.volume_sfx = value / 100.0
	apply_audio_settings()
	Settings.save()

func apply_audio_settings():
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(Settings.volume_master)
	)

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(Settings.volume_music)
	)

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(Settings.volume_sfx)
	)
