class_name DuelQueueManager
extends Node


signal added_pair(duel_pair: DuelPair)
signal removed_pair(duel_pair: DuelPair)


@export var _duel_call_manager: DuelCallManager
@export var _duel_scene_provider: DuelSceneProvider


var _duel_queue: Array[DuelPair] = []


func _ready() -> void:
	_duel_call_manager.opponents_matched.connect(_on_new_duel_call)
	_duel_scene_provider.finished_duel.connect(_on_finished_duel)


func _on_new_duel_call(first_nickname: String, second_nickname: String) -> void:
	var first_player = PlayerManager.get_or_create_player(first_nickname)
	var second_player = PlayerManager.get_or_create_player(second_nickname)

	if _duel_scene_provider.has_free_scenes():
		var scene = _duel_scene_provider.pop_free_scene()
		scene.initiate_battle(first_player, second_player)
	else:
		var pair = DuelPair.new(first_player, second_player)
		_duel_queue.push_back(pair)
		added_pair.emit(pair)


func _on_finished_duel() -> void:
	if _duel_queue.is_empty():
		return

	var pair = _duel_queue.pop_front()
	var scene = _duel_scene_provider.pop_free_scene()
	scene.initiate_battle(pair.first_player, pair.second_player)
	removed_pair.emit(pair)
