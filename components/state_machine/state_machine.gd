class_name StateMachine
extends Node


@export var state_initializer: StateInitializer

var _state: State


func _ready() -> void:
	await owner.ready
	for child in get_children():
		var state = child as State
		state_initializer.initialize_state(state, owner)
		state.queried_state_change.connect(change_state_to)
		state._initialize()
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
	_state.is_active = false

	_state = get_node(new_state)

	_state.is_active = true
	_state._enter()
