class_name DuelSceneStateInitializer
extends StateInitializer


func initialize_state(state: State, owner: Node) -> void:
	var duel_state = state as DuelSceneState
	if duel_state:
		duel_state.duel_scene = owner
