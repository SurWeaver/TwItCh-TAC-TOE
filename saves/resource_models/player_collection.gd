class_name PlayerCollection
extends Resource


@export var players: Array[Player] = []


func get_player(nickname: String) -> Player:
	for player in players:
		if player.nickname == nickname:
			return player

	return null

func add_player(new_player: Player) -> void:
	if get_player(new_player.nickname) == null:
		players.append(new_player)
