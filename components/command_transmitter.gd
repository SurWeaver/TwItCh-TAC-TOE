class_name CommandTransmitter
extends Node


@export var _queue_manager: DuelQueueManager


var _playing_duel_scenes: Dictionary[String, DuelScene] = {}


func _ready() -> void:
	_queue_manager.duel_started.connect(_on_duel_started)


func transmit_symbol_placement(author: String, coordinate_index: int) -> void:
	if not _playing_duel_scenes.has(author):
		return

	var scene = _playing_duel_scenes[author]
	scene.process_symbol_placement(author, coordinate_index)


func _on_duel_started(duel_scene: DuelScene, first_player: String, second_player: String) -> void:
	_playing_duel_scenes[first_player] = duel_scene
	_playing_duel_scenes[second_player] = duel_scene

	duel_scene.finished_duel.connect(_clear_from_players)

func _clear_from_players(duel_scene: DuelScene) -> void:
	var player_nicknames = duel_scene.get_finished_players_nicknames()
	for nickname in player_nicknames:
		_playing_duel_scenes.erase(nickname)

	duel_scene.finished_duel.disconnect(_clear_from_players)
