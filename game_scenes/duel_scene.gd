class_name DuelScene
extends Node2D


signal finished_duel(duel_scene: DuelScene)


var _finished_first_player_nickname: String = ""
var _finished_second_player_nickname: String = ""

var _current_first_player_nickname: String = ""
var _current_second_player_nickname: String = ""

func get_finished_players_nicknames() -> Array[String]:
	var names: Array[String] = []
	if _finished_first_player_nickname != "":
		names.append(_finished_first_player_nickname)
	if _finished_second_player_nickname != "":
		names.append(_finished_second_player_nickname)
	return names

func initiate_battle(first_player: Player, second_player: Player) -> void:

	pass

func process_symbol_placement(nickname: String, coordinate_index: int) -> void:
	pass
