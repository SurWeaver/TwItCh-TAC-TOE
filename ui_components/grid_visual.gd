@tool
class_name GridVisual
extends NinePatchRect


signal grid_size_updated


## Количество пикселей одной клетки решётки. Должно равняться примерно 1/3 текстуры.
@export_range(1, 1000, 1, "suffix:px") var tile_size: int:
	get():
		return tile_size
	set(value):
		tile_size = value
		_update_look()


## Количество желаемых клеток на решётке
@export_range(3, 100, 1, "suffix:cells") var grid_size: int = 3:
	get():
		return grid_size
	set(value):
		grid_size = value
		_update_look()


func _update_look() -> void:
	custom_minimum_size = Vector2.ONE * grid_size * tile_size
	grid_size_updated.emit()
