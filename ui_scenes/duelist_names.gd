class_name DuelistNames
extends Control


@export var transition_time: float = 0.5


var _tween: Tween

@onready var _first_duelist: Label = %FirstDuelist
@onready var _second_duelist: Label = %SecondDuelist


func _ready() -> void:
	modulate = Color.TRANSPARENT


func show_players(first_player: Player, second_player: Player) -> void:
	_first_duelist.text = first_player.nickname
	_first_duelist.modulate = first_player.color

	_second_duelist.text = second_player.nickname
	_second_duelist.modulate = second_player.color

	_reset_tween()
	_tween.tween_property(self, "modulate", Color.WHITE, transition_time)

func hide_names() -> void:
	_reset_tween()
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, transition_time)

func _reset_tween() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
