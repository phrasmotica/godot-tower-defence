## Projectile that damages all enemies in an area
## centred on the enemy that is struck.
class_name Cannonball extends Projectile

enum State { MOVING, EXPLODING }

@export_range(1, 6)
var area_radius := 1

@onready
var appearance: CannonballAppearance = %Appearance

@onready
var colliders: BulletColliders = %Colliders

var _state_factory := CannonballStateFactory.new()
var _current_state: CannonballState = null

var _movement: ProjectileMovement = null

func _ready() -> void:
	_movement = ProjectileMovement.new(direction, effective_range, speed)

	colliders.setup(self)

	switch_state(State.MOVING)

func switch_state(state: State, state_data := CannonballStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance,
		colliders,
		_movement)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "CannonballStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)
