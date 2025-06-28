class_name BulletStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Bullet.State.MOVING: BulletStateMoving,
	}

func get_fresh_state(state: Bullet.State) -> BulletState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
