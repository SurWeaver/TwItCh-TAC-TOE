@tool
class_name GridSettings
extends Node


signal size_changed


## Количество желаемых клеток на решётке (Размер ограничен количеством букв латиницы)
@export_range(3, 26, 1, "suffix:cells") var grid_size: int = 3:
	get():
		return grid_size
	set(value):
		grid_size = clampi(value, 3, 26)
		size_changed.emit()
