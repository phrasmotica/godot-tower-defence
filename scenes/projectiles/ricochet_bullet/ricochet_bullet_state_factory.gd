class_name RicochetBulletStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		RicochetBullet.State.MOVING: RicochetBulletStateMoving,
	}

func get_fresh_state(state: RicochetBullet.State) -> RicochetBulletState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
