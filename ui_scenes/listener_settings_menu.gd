extends Control


@onready var channel_name_edit: LineEdit = %ChannelNameEdit


func _on_start_button_pressed() -> void:
	TwitchListener.set_channel(channel_name_edit.text)
	TwitchListener.start()

func _on_stop_button_pressed() -> void:
	TwitchListener.stop()
