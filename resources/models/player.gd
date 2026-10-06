class_name Player
extends Resource


@export var nickname: String
@export var color: Color

@export var wins: int = 0
@export var loses: int = 0
@export var ties: int = 0


func get_match_count() -> int:
	return wins + loses + ties
