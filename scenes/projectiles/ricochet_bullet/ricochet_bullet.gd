## Bullet that bounces off the the hit enemy
## and ricochets into its nearest neighbour.
class_name RicochetBullet extends Node2D

enum State { MOVING }

@export
var projectile_stats: ProjectileStats

@export_range(1, 2)
var max_ricochets := 1

@onready
var colliders: ProjectileColliders = %Colliders

@onready
var ricochet_count := max_ricochets

var _state_factory := RicochetBulletStateFactory.new()
var _current_state: RicochetBulletState = null

var _movement: ProjectileMovement = null

func _ready() -> void:
	_movement = ProjectileMovement.new(
		projectile_stats.direction,
		projectile_stats.effective_range,
		projectile_stats.speed)

	colliders.setup(projectile_stats)

	switch_state(State.MOVING)

func switch_state(state: State, state_data := RicochetBulletStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		colliders,
		_movement)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "RicochetBulletStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)
