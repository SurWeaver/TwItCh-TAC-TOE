extends Node


signal message_sent(author: String, message: String)

signal connection_established
signal connection_lost

enum ConnectionState { DISCONNECTED, CONNECTING, AUTHORIZING, READY }

const LINE_BREAK = "\r\n"
const SERVER_HOST: String = "irc.chat.twitch.tv"
const SERVER_PORT: int = 6667
const TWITCH_GUEST_NAME_PREFIX = "justinfan"


var _tcp_client: StreamPeerTCP = StreamPeerTCP.new()

## Используем длинное случайное число для уникальности гостевого входа
var _listener_nickname: String = TWITCH_GUEST_NAME_PREFIX + str(randi_range(100000, 999999))

var _channel: String = "#"
var _reconnect_time: float = 5.0

var _current_state: ConnectionState = ConnectionState.DISCONNECTED


func _ready() -> void:
	set_process(false)


func set_channel(channel_nickname: String) -> void:
	_channel = "#" + channel_nickname.to_lower()

func get_channel() -> String:
	return _channel.trim_prefix("#")

func is_listening() -> bool:
	return _current_state == ConnectionState.READY

func set_reconnect_time(reconnect_time: float) -> void:
	_reconnect_time = reconnect_time

func start() -> void:
	if _channel == "#":
		print("Неверное имя канала!")
		return
	_connect_to_twitch()

func stop() -> void:
	_change_state(ConnectionState.DISCONNECTED)
	_tcp_client.disconnect_from_host()
	connection_lost.emit()
	set_process(false)


func _connect_to_twitch() -> void:
	_change_state(ConnectionState.CONNECTING)
	_tcp_client.connect_to_host(SERVER_HOST, SERVER_PORT)
	set_process(true)

func _process(_delta: float) -> void:
	_tcp_client.poll()
	var status = _tcp_client.get_status()

	if status == StreamPeerTCP.STATUS_ERROR or status == StreamPeerTCP.STATUS_NONE:
		if _current_state != ConnectionState.DISCONNECTED:
			_change_state(ConnectionState.DISCONNECTED)
			connection_lost.emit()
			await get_tree().create_timer(_reconnect_time).timeout
			_connect_to_twitch()
		return

	match _current_state:
		ConnectionState.CONNECTING:
			if status == StreamPeerTCP.STATUS_CONNECTED:
				_change_state(ConnectionState.AUTHORIZING)
				## Важно: делаем небольшую паузу (один кадр), чтобы сокет стабилизировался
				await get_tree().process_frame
				_send_irc_line("NICK " + _listener_nickname)
				_send_irc_line("JOIN " + _channel)
				_change_state(ConnectionState.READY)
				connection_established.emit()

		ConnectionState.READY:
			_read_irc_data()

func _send_irc_line(line: String) -> void:
	if _tcp_client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		_tcp_client.put_data((line + LINE_BREAK).to_utf8_buffer())

func _read_irc_data() -> void:
	var bytes_available = _tcp_client.get_available_bytes()
	if bytes_available > 0:
		var data = _tcp_client.get_utf8_string(bytes_available)
		var lines = data.split(LINE_BREAK)

		for line in lines:
			if line.is_empty():
				continue

			if line.begins_with("PING"):
				_send_irc_line("PONG :tmi.twitch.tv")
				continue

			if "PRIVMSG" in line:
				_parse_twitch_message(line)

func _parse_twitch_message(raw_line: String) -> void:
	var name_start = raw_line.find(":") + 1
	var name_end = raw_line.find("!")
	if name_start == 0 or name_end == -1:
		return
	var username: String = raw_line.substr(name_start, name_end - name_start)

	var msg_search_str = "PRIVMSG " + _channel + " :"
	var msg_start = raw_line.find(msg_search_str)
	if msg_start == -1:
		return
	msg_start += msg_search_str.length()
	var message_text: String = raw_line.substr(msg_start)

	_on_new_chat_message(username, message_text)

func _on_new_chat_message(author: String, text: String) -> void:
	print("[ЧАТ] ", author, ": ", text)
	message_sent.emit(author, text)

func _change_state(new_state: ConnectionState) -> void:
	_current_state = new_state

	match new_state:
		ConnectionState.DISCONNECTED:
			print("Соединение потеряно")
		ConnectionState.CONNECTING:
			print("Установка TCP соединения")
		ConnectionState.AUTHORIZING:
			print("Отправка авторизации Twitch")
		ConnectionState.READY:
			print("Соединение установлено")
