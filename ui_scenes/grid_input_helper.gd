class_name GridInputHelper
extends GridContainer


const LABEL_VISIBLE_COLOR: Color = Color.WHITE
const TRANSITION_TIME: float = 1.0
const HIDE_TIME: float = 0.2


@export var _helper_visible_color: Color

func _ready() -> void:
	modulate = Color.TRANSPARENT

func show_all() -> void:
	for child in get_children():
		(child as Label).modulate = LABEL_VISIBLE_COLOR

	var tween = create_tween()
	tween.tween_property(self, "modulate", _helper_visible_color, TRANSITION_TIME)

func hide_all() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, TRANSITION_TIME)

func hide_coordinate(coordinate_index: int) -> void:
	var label = get_child(coordinate_index) as Label
	if label:
		var tween = create_tween()
		tween.tween_property(label, "modulate", Color.TRANSPARENT, HIDE_TIME)
