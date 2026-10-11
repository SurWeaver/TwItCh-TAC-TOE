extends Node


var streamer_nickname: String = ""


func _ready() -> void:
	if FileAccess.file_exists(Constants.SETTINGS_PATH):
		var settings = load(Constants.SETTINGS_PATH) as SavedSettings
		streamer_nickname = settings.streamer_nickname
	else:
		var empty_settings = SavedSettings.new()
		ResourceSaver.save(empty_settings, Constants.SETTINGS_PATH)

func _exit_tree() -> void:
	var settings = load(Constants.SETTINGS_PATH) as SavedSettings
	settings.streamer_nickname = streamer_nickname
	ResourceSaver.save(settings, Constants.SETTINGS_PATH)
