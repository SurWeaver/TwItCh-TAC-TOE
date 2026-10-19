class_name StateMachine
extends Node


var state: State


func _ready() -> void:
	await owner.ready
	for child in get_children():
		(child as State).queried_state_change.connect(change_state_to)
	state = get_child(0)
	state._enter()

func _unhandled_input(event: InputEvent) -> void:
	state._handle_input(event)

func _process(delta: float) -> void:
	state._update(delta)


func change_state_to(new_state: String) -> void:
	if not has_node(new_state):
		return

	state._exit()
	state = get_node(new_state)
	state._enter()
