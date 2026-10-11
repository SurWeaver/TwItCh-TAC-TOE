@abstract
class_name Converter
extends Node


const INVALID_INDEX: int = -1


static func to_coordinate_index(coordinate: String) -> int:
	if not coordinate.is_valid_int():
		return INVALID_INDEX
	return coordinate.to_int() - 1
