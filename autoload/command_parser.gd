extends Node


## message: !duel @nickname
signal duel_call(author: String, opponent: String)

## message: !color red | !color #23FFBB
signal changed_color(author: String, color: Color)

## message: !1
signal symbol_placed(author: String, coordinate: Vector2i)



const DEFAULT_UNACCEPTABLE_COLOR = Color(0, 0, 0, 0)


func _ready() -> void:
	TwitchListener.message_sent.connect(_parse_message)

func _parse_message(author: String, message: String) -> void:
	if "!duel" in message:
		_parse_duel(author, message)
		return

	if message.begins_with("!color"):
		_parse_color(author, message)
		return

	if message.begins_with("!"):
		_parse_coordinate(author, message)
		return


func _parse_duel(author: String, message: String) -> void:
	if "@" not in message:
		duel_call.emit(author, Duel.NO_OPPONENT)
		return

	var at_symbol = message.find("@")
	var opponent_name = message.substr(at_symbol + 1)
	opponent_name = opponent_name.get_slice(" ", 0)
	duel_call.emit(author, opponent_name)

func _parse_color(author: String, message: String) -> void:
	var color_string = message.trim_prefix("!color ")
	var color = Color.from_string(color_string, DEFAULT_UNACCEPTABLE_COLOR)
	if color != DEFAULT_UNACCEPTABLE_COLOR:
		changed_color.emit(author, color)

func _parse_coordinate(author: String, message: String) -> void:
	var letter_coordinate = message.trim_prefix("!").get_slice(" ", 0)

	var coordinate = GridConvert.to_vec_from_letter_coord(letter_coordinate)
	if coordinate != GridConvert.INVALID_COORDINATE:
		symbol_placed.emit(author, coordinate)
