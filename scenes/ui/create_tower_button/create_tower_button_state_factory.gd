class_name CreateTowerButtonStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		CreateTowerButton.State.DISABLED: CreateTowerButtonStateDisabled,
		CreateTowerButton.State.ENABLED: CreateTowerButtonStateEnabled,
		CreateTowerButton.State.CREATING: CreateTowerButtonStateCreating,
	}

func get_fresh_state(state: CreateTowerButton.State) -> CreateTowerButtonState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
