@tool
class_name GridInputHelper
extends GridContainer


const LABEL_VISIBLE_COLOR: Color = Color.WHITE
const TRANSITION_TIME: float = 1.0
const HIDE_TIME: float = 0.2


@export var _grid_visual: GridVisual


@export var _helper_visible_color: Color = Color(1.0, 1.0, 1.0, 0.5)


func _ready() -> void:
	_grid_visual.grid_size_updated.connect(_update_look)

	modulate = Color.TRANSPARENT
	if get_child_count() == 0:
		_update_look()

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


func _update_look() -> void:
	for child in get_children():
		child.queue_free()

	columns = _grid_visual.grid_size

	var cell_count = _grid_visual.grid_size ** 2

	for i in range(cell_count):
		var label = Label.new()
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.text = "!%d" % (i + 1)
		add_child(label)
