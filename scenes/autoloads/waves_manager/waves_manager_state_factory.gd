class_name WavesManagerStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		WavesManager.State.DISABLED: WavesManagerStateDisabled,
		WavesManager.State.WAITING: WavesManagerStateWaiting,
	}

func get_fresh_state(state: WavesManager.State) -> WavesManagerState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
