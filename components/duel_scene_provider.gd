class_name DuelSceneProvider
extends Node2D


signal finished_duel


var _free_duel_scenes: Array[DuelScene] = []


func _ready() -> void:
	for child in get_children():
		_free_duel_scenes.append(child)
		(child as DuelScene).finished_duel.connect(_on_finished_duel)


func has_free_scenes() -> bool:
	return not _free_duel_scenes.is_empty()

func pop_free_scene() -> DuelScene:
	if not has_free_scenes():
		return null

	var random_index = randi_range(0, _free_duel_scenes.size() - 1)
	return _free_duel_scenes.pop_at(random_index)


func _on_finished_duel(duel_scene: DuelScene) -> void:
	_free_duel_scenes.append(duel_scene)
	finished_duel.emit()
