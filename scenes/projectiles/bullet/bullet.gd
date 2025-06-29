class_name Bullet extends Projectile

enum State { MOVING }

@onready
var colliders: BulletColliders = %Colliders

var _state_factory := BulletStateFactory.new()
var _current_state: BulletState = null

var _movement: ProjectileMovement = null

func _ready() -> void:
	_movement = ProjectileMovement.new(direction, effective_range, speed)

	colliders.setup(self)
	colliders.enemy_hit.connect(handle_collision)

	switch_state(State.MOVING)

func switch_state(state: State, state_data := BulletStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		_movement)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "BulletStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func handle_collision(enemy: Enemy) -> void:
	if _current_state != null:
		_current_state.handle_collision(enemy)
