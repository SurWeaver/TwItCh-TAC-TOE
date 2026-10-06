class_name DuelistNames
extends Control


@export var transition_time: float = 0.5


var _tween: Tween

@onready var first_duelist: Label = %FirstDuelist
@onready var second_duelist: Label = %SecondDuelist


func _ready() -> void:
	modulate = Color.TRANSPARENT


func show_names(first_name: String, second_name: String) -> void:
	first_duelist.text = first_name
	second_duelist.text = second_name

	_reset_tween()
	_tween.tween_property(self, "modulate", Color.WHITE, transition_time)

func hide_names() -> void:
	_reset_tween()
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, transition_time)

func _reset_tween() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
