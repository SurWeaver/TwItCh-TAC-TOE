class_name DuelPair
extends RefCounted


var first_player: Player
var second_player: Player


func _init(player_one: Player, player_two: Player) -> void:
	first_player = player_one
	second_player = player_two
