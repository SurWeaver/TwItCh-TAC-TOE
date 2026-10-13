extends Node


var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()

func get_chance(chance_percent: float) -> bool:
	return _rng.randf() > chance_percent
