extends Node

var resolution : Vector2i = Vector2i(1280, 720)
var fullscreen : bool = false
var volume_master : float = 1.0
var volume_music : float = 1.0
var volume_sfx : float = 1.0

const SAVE_PATH := "user://settings.json"

func save() -> void:
	var data = {
		"resolution": {"x": resolution.x, "y": resolution.y},
		"fullscreen": fullscreen,
		"volume_master": volume_master,
		"volume_music": volume_music,
		"volume_sfx": volume_sfx
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.WRITE)
	if file == null:
		push_error("Não foi possível abrir " + SAVE_PATH + " para escrita.")
		return

	var json := JSON.new()
	var text := json.stringify(data)
	file.store_string(text)
	file.close()


func load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.READ)
	if file == null:
		push_error("Não foi possível abrir " + SAVE_PATH + " para leitura.")
		return

	var text := file.get_as_text()
	file.close()

	var json := JSON.new()
	var parsed: Dictionary = json.parse_string(text)

	if parsed.error != OK:
		push_warning("Erro ao parsear settings.json: %s" % parsed.error_string)
		return

	var data: Dictionary = parsed.result

	if data.has("resolution"):
		resolution = Vector2i(
			data.resolution.x,
			data.resolution.y
		)

	fullscreen = data.get("fullscreen", fullscreen)
	volume_master = data.get("volume_master", volume_master)
	volume_music = data.get("volume_music", volume_music)
	volume_sfx = data.get("volume_sfx", volume_sfx)
