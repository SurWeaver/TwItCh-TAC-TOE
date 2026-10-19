class_name StateMachine
extends Node


var _state: State


func _ready() -> void:
	await owner.ready
	for child in get_children():
		(child as State).queried_state_change.connect(change_state_to)
	_state = get_child(0)
	_state._enter()

func _unhandled_input(event: InputEvent) -> void:
	_state._handle_input(event)

func _process(delta: float) -> void:
	_state._update(delta)


func change_state_to(new_state: String) -> void:
	if not has_node(new_state):
		return

	_state._exit()
	_state = get_node(new_state)
	_state._enter()
