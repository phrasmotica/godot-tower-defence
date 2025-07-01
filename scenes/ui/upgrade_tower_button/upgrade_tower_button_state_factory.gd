class_name UpgradeTowerButtonStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		UpgradeTowerButton.State.ENABLED: UpgradeTowerButtonStateEnabled,
	}

func get_fresh_state(state: UpgradeTowerButton.State) -> UpgradeTowerButtonState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
