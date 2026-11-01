class_name ClockTimer
extends TextureProgressBar


@export var _visible_color: Color
@export var _animation_time: float = 0.3

@export var _timer: Timer


func _ready() -> void:
	modulate = _visible_color

	if not _timer:
		set_process(false)

func connect_to_timer(timer: Timer) -> void:
	_timer = timer
	set_process(true)
	_timer.tree_exited.connect(_on_timer_deleted)


func _process(_delta: float) -> void:
	var current_progress = _timer.time_left / _timer.wait_time * max_value
	value = current_progress


func animate_show() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", _visible_color, _animation_time)

func animate_hide() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, _animation_time)

func _on_timer_deleted() -> void:
	set_process(false)
