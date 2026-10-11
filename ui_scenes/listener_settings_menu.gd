extends Control


@onready var channel_name_edit: LineEdit = %ChannelNameEdit
@onready var status_label: Label = $StatusLabel


func _ready() -> void:
	if TwitchListener.is_listening():
		status_label.text = Locale.CONNECTED
		channel_name_edit.text = TwitchListener.get_channel()
	else:
		status_label.text = Locale.DISCONNECTED
		channel_name_edit.text = Settings.streamer_nickname
		_on_start_button_pressed()

	TwitchListener.connection_established.connect(_on_connection_established)
	TwitchListener.connection_lost.connect(_on_connection_lost)


func _on_start_button_pressed() -> void:
	TwitchListener.set_channel(channel_name_edit.text)
	TwitchListener.start()
	Settings.streamer_nickname = channel_name_edit.text

func _on_stop_button_pressed() -> void:
	TwitchListener.stop()

func _on_connection_established() -> void:
	status_label.text = tr(Locale.CONNECTED)

func _on_connection_lost() -> void:
	status_label.text = tr(Locale.DISCONNECTED)
