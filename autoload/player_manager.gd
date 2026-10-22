extends Node


var _player_collection: PlayerCollection


func _ready() -> void:
	if FileAccess.file_exists(FilePaths.PLAYER_COLLECTION_PATH):
		_player_collection = load(FilePaths.PLAYER_COLLECTION_PATH)
	else:
		_player_collection = PlayerCollection.new()

func get_player(nickname: String) -> Player:
	return _player_collection.get_player(nickname)


## Небезопасная функция, если игроки начнут спамить несуществующими никами.
func get_or_create_player(nickname: String) -> Player:
	var player = _player_collection.get_player(nickname)
	if player:
		return player

	var new_player = Player.new()
	new_player.nickname = nickname
	new_player.color = Refs.get_random_color()

	_player_collection.add_player(new_player)

	return new_player

func _exit_tree() -> void:
	ResourceSaver.save(_player_collection, FilePaths.PLAYER_COLLECTION_PATH)
