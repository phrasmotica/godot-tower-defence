class_name UpgradeTowerButtonStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		UpgradeTowerButton.State.DISABLED: UpgradeTowerButtonStateDisabled,
		UpgradeTowerButton.State.ENABLED: UpgradeTowerButtonStateEnabled,
		UpgradeTowerButton.State.UNAVAILABLE: UpgradeTowerButtonStateUnavailable,
	}

func get_fresh_state(state: UpgradeTowerButton.State) -> UpgradeTowerButtonState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
