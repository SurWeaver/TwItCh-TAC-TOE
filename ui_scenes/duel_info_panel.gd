class_name DuelInfoPanel
extends Control


signal finished_showing


@export var _show_time: float = 3.0
@export var _transition_time: float = 0.25


var _queried_texts: Array[String] = []
var _queried_show_times: Array[float] = []

var _tween: Tween
var _is_animating: bool = false


@onready var info_label: RichTextLabel = %InfoLabel


func _ready() -> void:
	modulate = Color.TRANSPARENT


func show_text(text: String, new_show_time: float = 0) -> void:
	if _is_animating:
		_queried_texts.push_back(text)
		_queried_show_times.push_back(new_show_time)
		return

	info_label.text = text

	_is_animating = true
	_tween_reset()
	_tween.tween_property(self, "modulate", Color.WHITE, _transition_time)
	_tween.tween_interval(_show_time if new_show_time <= 0 else new_show_time)
	_tween.tween_property(self, "modulate", Color.TRANSPARENT, _transition_time)
	_tween.tween_property(self, "_is_animating", false, 0.001)
	_tween.tween_callback(_show_queried_text.call_deferred)


func _show_queried_text() -> void:
	if _queried_texts.is_empty():
		finished_showing.emit()
		return

	show_text(_queried_texts.pop_front(), _queried_show_times.pop_front())

func _tween_reset() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
