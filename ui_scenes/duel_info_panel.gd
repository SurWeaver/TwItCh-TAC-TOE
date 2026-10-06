class_name DuelInfoPanel
extends Control


@export var show_time: float = 3.0
@export var transition_time: float = 0.5


var _queried_texts: Array[String] = []

var _tween: Tween
var _is_animating: bool = false


@onready var info_label: Label = %InfoLabel


func _ready() -> void:
	modulate = Color.TRANSPARENT


func show_text(text: String) -> void:
	if _is_animating:
		_queried_texts.push_back(text)
		return

	info_label.text = text

	_is_animating = true
	_tween_reset()
	_tween.tween_property(self, "modulate", Color.WHITE, transition_time)
	_tween.tween_interval(show_time)
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, transition_time)
	_tween.tween_property(self, "_is_animating", false, 0.001)
	_tween.tween_callback(_show_queried_text.call_deferred)


func _show_queried_text() -> void:
	if _queried_texts.is_empty():
		return

	show_text(_queried_texts.pop_front())

func _tween_reset() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
