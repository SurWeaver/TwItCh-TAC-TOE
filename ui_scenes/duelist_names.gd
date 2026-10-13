class_name DuelistNames
extends Control



@export var _transition_time: float = 0.5

@export var _highlight_size: float = 1.5
@export var _highlight_change_time: float = 0.3

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
	_tween.tween_property(self, "modulate", Color.WHITE, _transition_time)

func hide_players() -> void:
	_reset_tween()
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, _transition_time)


func highlight_first_player() -> void:
	_highlight_label(_first_duelist, _second_duelist)

func highlight_second_player() -> void:
	_highlight_label(_second_duelist, _first_duelist)

func _highlight_label(main_label: Label, secondary_label: Label) -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(main_label, "scale", Vector2.ONE * _highlight_size, _highlight_change_time)
	tween.tween_property(secondary_label, "scale", Vector2.ONE, _highlight_change_time)

func dehighlight() -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(_first_duelist, "scale", Vector2.ONE, _highlight_change_time)
	tween.tween_property(_second_duelist, "scale", Vector2.ONE, _highlight_change_time)


func _reset_tween() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
