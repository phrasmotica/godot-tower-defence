class_name EnemyState
extends Node

signal state_transition_requested(new_state: Enemy.State, state_data: EnemyStateData)

var _enemy: Enemy = null
var _state_data: EnemyStateData = null
var _appearance: EnemyAppearance = null
var _colliders: EnemyColliders = null
var _info: EnemyInfo = null
var _interaction: EnemyInteraction = null
var _movement: EnemyMovement = null
var _stats: EnemyStats = null

func setup(
	enemy: Enemy,
	state_data: EnemyStateData,
	appearance: EnemyAppearance,
	colliders: EnemyColliders,
	info: EnemyInfo,
	interaction: EnemyInteraction,
	movement: EnemyMovement,
	stats: EnemyStats,
) -> void:
	_enemy = enemy
	_state_data = state_data
	_appearance = appearance
	_colliders = colliders
	_info = info
	_interaction = interaction
	_movement = movement
	_stats = stats

func transition_state(
	new_state: Enemy.State,
	state_data := EnemyStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func accelerate(delta: float) -> void:
	_movement.accelerate(delta)

func move(delta: float) -> void:
	_enemy.emit_move_requested(delta * _movement.get_current_speed())

func can_be_slowed() -> bool:
	return false

func can_be_paralysed() -> bool:
	return false

func can_be_poisoned() -> bool:
	return false

func can_take_damage() -> bool:
	return true

func handle_aoe(projectile_stats: ProjectileStats) -> void:
	# gentler knockback for an indirect hit
	handle_damage(projectile_stats.damage)
	handle_knockback(projectile_stats.knockback, 0.5)

func handle_bolt(bolt_stats: TowerLevelStats) -> void:
	handle_damage(bolt_stats.damage)
	handle_knockback(bolt_stats.projectile_knockback)

func handle_strike(projectile_stats: ProjectileStats) -> void:
	handle_damage(projectile_stats.damage)
	handle_knockback(projectile_stats.knockback, 1.0)

func handle_damage(amount: float) -> void:
	var new_health = _stats.take_damage(amount)
	_appearance.set_current_health(new_health)

	if new_health > 0:
		_appearance.animate_peek_health()
	else:
		transition_state(Enemy.State.DYING)

func handle_knockback(amount: float, mult := 1.0) -> void:
	if mult > 0:
		_movement.knockback(amount * mult)
