class_name DuelScene
extends Control


signal player_moved(player: Player, coordinate: Vector2i)

signal finished_duel(duel_scene: DuelScene)


const STATE_FREE = "Free"
const STATE_GAME_STARTING = "GameStarting"
const STATE_FIRST_PLAYER_MOVES = "FirstPlayerMoves"
const STATE_SECOND_PLAYER_MOVES = "SecondPlayerMoves"
const STATE_DUEL_FINISHED = "DuelFinished"


var _finished_first_player_nickname: String = ""
var _finished_second_player_nickname: String = ""

var current_first_player: Player
var current_second_player: Player


@onready var _first_player_name: PlayerName = %FirstPlayerName
@onready var _second_player_name: PlayerName = %SecondPlayerName

@onready var _grid_settings: GridSettings = %GridSettings
@onready var _state_machine: StateMachine = %StateMachine



func _ready() -> void:
#	TODO: Удалить
	var first = PlayerManager.get_player("themrtka4")
	var second = PlayerManager.get_player("surweaver")
	initiate_battle.call_deferred(first, second)


func get_finished_players_nicknames() -> Array[String]:
	return [_finished_first_player_nickname, _finished_second_player_nickname]

func initiate_battle(first_player: Player, second_player: Player) -> void:
	_assign_players_by_win_rate(first_player, second_player)
	_first_player_name.set_player(current_first_player)
	_second_player_name.set_player(current_second_player)

	_state_machine.change_state_to(STATE_GAME_STARTING)

func show_player_names() -> void:
	_first_player_name.show_player()
	_second_player_name.show_player()

func hide_player_names() -> void:
	_first_player_name.hide_player()
	_second_player_name.hide_player()

func highlight_first_player_name() -> void:
	_first_player_name.highlight()
	_second_player_name.dehighlight()

func highlight_second_player_name() -> void:
	_first_player_name.dehighlight()
	_second_player_name.highlight()


func _assign_players_by_win_rate(first_player: Player, second_player: Player) -> void:
	var first_order_player = Player.who_wins_less(first_player, second_player)
	if first_order_player:
		current_first_player = first_order_player
		current_second_player = first_player if first_order_player == second_player else second_player
	else:
		if Randomizer.get_chance(0.50):
			current_first_player = first_player
			current_second_player = second_player
		else:
			current_first_player = second_player
			current_second_player = first_player


func process_symbol_placement(nickname: String, coordinate: Vector2i) -> void:
	var existing_player = _get_player(nickname)
	if not existing_player or not _coordinate_exists(coordinate):
		return

	player_moved.emit(existing_player, coordinate)

func _get_player(nickname: String) -> Player:
	if nickname == current_first_player.nickname:
		return current_first_player
	elif nickname == current_second_player.nickname:
		return current_second_player

	return null

func _coordinate_exists(coordinate: Vector2i) -> bool:
	var converted_index = GridConvert.to_index_from_vec(coordinate, _grid_settings.grid_size)
	return converted_index != GridConvert.INVALID_INDEX


func save_finished_players() -> void:
	_finished_first_player_nickname = current_first_player.nickname
	_finished_second_player_nickname = current_second_player.nickname
