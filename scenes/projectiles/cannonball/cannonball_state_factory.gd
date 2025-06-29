class_name CannonballStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Cannonball.State.MOVING: CannonballStateMoving,
		Cannonball.State.EXPLODING: CannonballStateExploding,
	}

func get_fresh_state(state: Cannonball.State) -> CannonballState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
