class_name ClockTimer
extends TextureProgressBar


@export var _visible_color: Color
@export var _animation_time: float = 0.3

@export var _turn_timer: Timer


func _ready() -> void:
	modulate = _visible_color

func _process(_delta: float) -> void:
	var current_progress = _turn_timer.time_left / _turn_timer.wait_time * max_value
	value = current_progress


func animate_show() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", _visible_color, _animation_time)

func animate_hide() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, _animation_time)
