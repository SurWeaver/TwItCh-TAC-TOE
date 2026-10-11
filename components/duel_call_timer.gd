class_name DuelCallTimer
extends Timer


const CALL_ANSWER_TIME: float = 10.0


var _author: String
var _opponent: String


func _init(author: String, opponent: String = Constants.NO_OPPONENT) -> void:
	autostart = true
	start(CALL_ANSWER_TIME)
	_author = author
	_opponent = opponent
	timeout.connect(queue_free)
	TwitchListener.connection_lost.connect(_autostop_on_connection_loss)
	TwitchListener.connection_established.connect(_autoplay_on_reconnect)


func get_author() -> String:
	return _author

func get_opponent() -> String:
	return _opponent

func has_participant(nickname: String) -> bool:
	return nickname == _author or (_opponent == nickname and _opponent != Constants.NO_OPPONENT)

func has_concrete_opponent() -> bool:
	return _opponent != Constants.NO_OPPONENT


func _autostop_on_connection_loss() -> void:
	paused = true

func _autoplay_on_reconnect() -> void:
	paused = false
