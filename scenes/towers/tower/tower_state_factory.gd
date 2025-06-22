class_name TowerStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Tower.State.PLACING: TowerStatePlacing,
		Tower.State.WARMUP: TowerStateWarmup,
		Tower.State.FIRING: TowerStateFiring,
		Tower.State.UPGRADING: TowerStateUpgrading,
		Tower.State.DISABLED: TowerStateDisabled,
		Tower.State.SELLING: TowerStateSelling,
	}

func get_fresh_state(state: Tower.State) -> TowerState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
