@abstract
class_name State
extends Node

@warning_ignore("unused_signal")
signal queried_state_change(new_state: StringName)


var is_active: bool = false


func _initialize() -> void:
	pass

@warning_ignore("unused_parameter")
func _handle_input(event: InputEvent) -> void:
	pass

@warning_ignore("unused_parameter")
func _update(delta: float) -> void:
	pass

func _enter() -> void:
	pass

func _exit() -> void:
	pass
