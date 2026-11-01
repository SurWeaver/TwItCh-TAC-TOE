class_name PlayerOccupationObserver
extends Node


@export var _duel_scene_container: Node
@export var _duel_call_manager: DuelCallManager


func _ready() -> void:
	for child in _duel_scene_container.get_children():
		var duel_scene = child as DuelScene
		if duel_scene:
			duel_scene.finished_duel.connect(_on_finished_duel)


func _on_finished_duel(duel_scene: DuelScene) -> void:
	var player_nicknames = duel_scene.get_finished_players_nicknames()
	_duel_call_manager.free_players(player_nicknames)
