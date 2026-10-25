extends HBoxContainer


const LETTERS_FOR_PLAYERS = "zxcvbnm"

var _players: Array[Player] = []
var _selectedPlayer: Player = null
var _selectedPlayerIndex: int = 0


func _ready() -> void:
	for letter in LETTERS_FOR_PLAYERS:
		var nickname = (letter + letter + letter).capitalize()
		var mokPlayer = PlayerManager.get_or_create_player(nickname)
		_players.append(mokPlayer)

	_set_selected_player(_players[0])


func _on_previous_player_button_pressed() -> void:
	_selectedPlayerIndex = _selectedPlayerIndex - 1
	if _selectedPlayerIndex < 0:
		_selectedPlayerIndex = _players.size() - 1
	_set_selected_player(_players[_selectedPlayerIndex])

func _on_next_player_button_pressed() -> void:
	_selectedPlayerIndex = (_selectedPlayerIndex + 1) % _players.size()
	_set_selected_player(_players[_selectedPlayerIndex])

func _set_selected_player(player: Player) -> void:
	_selectedPlayer = player
	$PlayerNicknameLabel.text = player.nickname


func _on_command_line_edit_text_submitted(new_text: String) -> void:
	if not new_text:
		return
	print("[ЧАТ] ", _selectedPlayer.nickname, ": ", new_text)
	TwitchListener.message_sent.emit(_selectedPlayer.nickname, new_text)
	$CommandLineEdit.clear()
