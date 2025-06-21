class_name GameUIStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		GameUI.State.ENABLED: GameUIStateEnabled,
		GameUI.State.DISABLED: GameUIStateDisabled,
		GameUI.State.CREATING_TOWER: GameUIStateCreatingTower,
		GameUI.State.PLACING_TOWER: GameUIStatePlacingTower,
	}

func get_fresh_state(state: GameUI.State) -> GameUIState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
