@tool
class_name GridVisual
extends NinePatchRect


@export var _grid_settings: GridSettings


## Количество пикселей одной клетки решётки. Должно равняться примерно 1/3 текстуры.
@export_range(1, 1000, 1, "suffix:px") var tile_size: int:
	get():
		return tile_size
	set(value):
		tile_size = value
		_update_look()


func _ready() -> void:
	_grid_settings.size_changed.connect(_update_look)


func _update_look() -> void:
	custom_minimum_size = Vector2.ONE * _grid_settings.grid_size * tile_size
