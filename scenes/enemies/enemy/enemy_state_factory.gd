class_name EnemyStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Enemy.State.MOVING: EnemyStateMoving,
		Enemy.State.PARALYSED: EnemyStateParalysed,
		Enemy.State.POISONED: EnemyStatePoisoned,
		Enemy.State.SLOWED: EnemyStateSlowed,
		Enemy.State.DYING: EnemyStateDying,
	}

func get_fresh_state(state: Enemy.State) -> EnemyState:
	assert(states.has(state), "State is missing!")
	return states.get(state).new()
