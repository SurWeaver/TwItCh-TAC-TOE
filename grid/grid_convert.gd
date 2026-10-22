@abstract
class_name GridConvert
extends Node


const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const INVALID_INDEX: int = -1
const INVALID_COORDINATE: Vector2i = Vector2i(-1, -1)
const INVALID_LETTER_COORDINATE: String = "--"


static func to_letter_coord_from_vec(vec: Vector2i) -> String:
	if vec.x < 0 or vec.y < 0 or vec.x >= ALPHABET.length() or vec.y >= ALPHABET.length():
		return INVALID_LETTER_COORDINATE

	return ALPHABET[vec.x] + ALPHABET[vec.y]

static func to_vec_from_letter_coord(letter_coord: String) -> Vector2i:
	var x_index = ALPHABET.find(letter_coord[0])
	var y_index = ALPHABET.find(letter_coord[1])
	if x_index == -1 or y_index == -1:
		return INVALID_COORDINATE

	return Vector2i(x_index, y_index)

static func to_letter_coord_from_index(index: int, width: int) -> String:
	var vec = to_vec_from_index(index, width)
	return to_letter_coord_from_vec(vec)


static func to_index_from_vec(vec: Vector2i, width: int) -> int:
	if width < 1 or vec.x < 0 or vec.y < 0:
		return INVALID_INDEX

	return vec.y * width + vec.x

static func to_vec_from_index(index: int, width: int) -> Vector2i:
	if width < 1 or index < 0:
		return INVALID_COORDINATE

	@warning_ignore("integer_division")
	return Vector2i(index % width, index / width)
