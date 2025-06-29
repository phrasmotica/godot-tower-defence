## Bullet that bounces off the the hit enemy
## and ricochets into its nearest neighbour.
class_name RicochetBullet extends Projectile

enum State { MOVING }

@export_range(1, 2)
var max_ricochets := 1

@onready
var ricochet_count := max_ricochets

var _state_factory := RicochetBulletStateFactory.new()
var _current_state: RicochetBulletState = null

var _movement: ProjectileMovement = null

func _ready() -> void:
	_movement = ProjectileMovement.new(direction, effective_range, speed)

	switch_state(State.MOVING)

func switch_state(state: State, state_data := RicochetBulletStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		_movement)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "RicochetBulletStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func handle_collision(enemy: Enemy) -> void:
	if _current_state != null:
		_current_state.handle_collision(enemy)
