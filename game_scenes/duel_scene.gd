class_name DuelScene
extends Control


signal finished_duel(duel_scene: DuelScene)


enum State {
	FREE,
	GAME_STARTING,
	FIRST_PLAYER_MOVES,
	SECOND_PLAYER_MOVES,
	BATTLE_FINISHED,
}


var _state: State = State.FREE

var _finished_first_player_nickname: String = ""
var _finished_second_player_nickname: String = ""

var _current_first_player: Player
var _current_second_player: Player


@onready var _duel_info_panel: DuelInfoPanel = %DuelInfoPanel
@onready var _first_player_name: PlayerName = %FirstPlayerName
@onready var _second_player_name: PlayerName = %SecondPlayerName
@onready var _player_turn_timer: Timer = %PlayerTurnTimer
@onready var _turn_timer_ui: ClockTimer = %ClockTimer
@onready var _grid_input_helper: GridInputHelper = %GridInputHelper

@onready var _grid_settings: GridSettings = %GridSettings


func _ready() -> void:
	_duel_info_panel.finished_showing.connect(_on_finished_showing_notifications)


func get_finished_players_nicknames() -> Array[String]:
	return [_finished_first_player_nickname, _finished_second_player_nickname]

func initiate_battle(first_player: Player, second_player: Player) -> void:
	_assign_players(first_player, second_player)

	_change_state(State.GAME_STARTING)


func _assign_players(first_player: Player, second_player: Player) -> void:
	var first_order_player = Player.who_wins_less(first_player, second_player)
	if first_order_player:
		_current_first_player = first_order_player
		_current_second_player = first_player if first_order_player == second_player else second_player
	else:
		if Randomizer.get_chance(0.50):
			_current_first_player = first_player
			_current_second_player = second_player
		else:
			_current_first_player = second_player
			_current_second_player = first_player


func _show_battle_start_notifications() -> void:
	_duel_info_panel.show_text(Locale.GET_READY_FOR_BATTLE, 0.5)
	_show_player_stats(_current_first_player)
	_duel_info_panel.show_text(Locale.VERSUS, 0.8)
	_show_player_stats(_current_second_player)
	_duel_info_panel.show_text(Locale.BATTLE_START, 0.5)#, 1.5)

func _show_player_stats(player: Player) -> void:
	## Ник игрока
	var player_stats = "[color=%s]%s[/color]\n" % [player.color.to_html(), player.nickname]
	## Раскрашенные В/П/Н
	player_stats += "[color=%s]%s[/color] / [color=%s]%s[/color] / [color=%s]%s[/color]\n" % [
		Refs.win_color.to_html(), tr(Locale.WIN), Refs.lose_color.to_html(), tr(Locale.LOSE),
		Refs.tie_color.to_html(), tr(Locale.TIE)
	]
	## Раскрашенные значения статистики
	player_stats += "[color=%s]%d[/color] / [color=%s]%d[/color] / [color=%s]%d[/color]" % [
		Refs.win_color.to_html(), player.wins, Refs.lose_color.to_html(), player.loses,
		Refs.tie_color.to_html(), player.ties
	]

	_duel_info_panel.show_text(player_stats, 0.5)


func process_symbol_placement(nickname: String, coordinate: Vector2i) -> void:
	pass


func _on_finished_showing_notifications() -> void:
	match _state:
		State.GAME_STARTING:

			_player_turn_timer.start()
			_turn_timer_ui.animate_show()

			_grid_input_helper.show_all()

			_change_state(State.FIRST_PLAYER_MOVES)

		State.BATTLE_FINISHED:
func _on_player_turn_timer_timeout() -> void:
	if _state == State.FIRST_PLAYER_MOVES:
		_change_state(State.BATTLE_FINISHED)
		_current_second_player.add_duel_result(Constants.DuelResult.WIN)
		_current_first_player.add_duel_result(Constants.DuelResult.LOSE)
	elif _state == State.SECOND_PLAYER_MOVES:
		_change_state(State.BATTLE_FINISHED)

func _change_state(new_state: State) -> void:
	_state = new_state

	match new_state:
		State.FREE:
			_first_player_name.hide_player()
			_second_player_name.hide_player()

			pass
		State.GAME_STARTING:
			_first_player_name.show_player(_current_first_player)
			_second_player_name.show_player(_current_second_player)

			_show_battle_start_notifications()
		State.FIRST_PLAYER_MOVES:
			_first_player_name.highlight()
			_second_player_name.dehighlight()
		State.SECOND_PLAYER_MOVES:
			_second_player_name.highlight()
			_first_player_name.dehighlight()
		State.BATTLE_FINISHED:
			_first_player_name.dehighlight()
			_second_player_name.dehighlight()

			_grid_input_helper.hide_all()
			_turn_timer_ui.animate_hide()

			_save_finished_players()


func _save_finished_players() -> void:
	_finished_first_player_nickname = _current_first_player.nickname
	_finished_second_player_nickname = _current_second_player.nickname
