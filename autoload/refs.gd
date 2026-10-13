extends Node2D


@export var default_player_colors: PackedColorArray

@export var win_color: Color
@export var lose_color: Color
@export var tie_color: Color

func get_random_color() -> Color:
	return default_player_colors[randi_range(0, default_player_colors.size() - 1)]
