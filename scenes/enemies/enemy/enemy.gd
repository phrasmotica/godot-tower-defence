class_name Enemy
extends Node2D

enum State { MOVING, PARALYSED, POISONED, SLOWED, DYING }

## Movement speed in pixels per second.
@export_range(100.0, 300.0)
var movement_speed := 150.0

## Amount of money rewarded for killing this enemy.
@export_range(1, 5)
var bounty := 1

@onready
var appearance: EnemyAppearance = %Appearance

@onready
var colliders: EnemyColliders = %Colliders

@onready
var movement: EnemyMovement = %Movement

@onready
var stats: EnemyStats = %Stats

var _info: EnemyInfo = null

var _state_factory := EnemyStateFactory.new()
var _current_state: EnemyState = null

signal move_requested(amount: float)

func _ready() -> void:
	_info = EnemyInfo.new(name, bounty)

	appearance.set_max_health(stats.starting_health)
	appearance.hide_health()

	colliders.setup(self)
	colliders.projectile_entered.connect(handle_strike)

	movement.set_base_speed(movement_speed)

	switch_state(State.MOVING)

func switch_state(state: State, state_data := EnemyStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance,
		colliders,
		_info,
		null, #interaction,
		movement,
		stats)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "EnemyStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func set_max_health(amount: float) -> void:
	# TODO: create a better abstraction in EnemyStats for this logic
	stats.starting_health = amount
	stats.set_current_health(amount)

	appearance.set_max_health(amount)

func scale_base_speed(factor: float) -> void:
	movement.scale_base_speed(factor)

func emit_move_requested(amount: float) -> void:
	move_requested.emit(amount)

func get_bounty() -> int:
	return _info.get_bounty()

func scale_bounty(factor: float) -> void:
	_info.scale_bounty(factor)

func can_be_slowed() -> bool:
	return _current_state != null and _current_state.can_be_slowed()

func slow(effect: SlowEffect) -> void:
	switch_state(State.SLOWED, EnemyStateData.build().with_effect(effect))

func can_be_paralysed() -> bool:
	return _current_state != null and _current_state.can_be_paralysed()

func paralyse(effect: ParalyseEffect) -> void:
	switch_state(State.PARALYSED, EnemyStateData.build().with_effect(effect))

func can_be_poisoned() -> bool:
	return _current_state != null and _current_state.can_be_poisoned()

func poison(effect: PoisonEffect) -> void:
	switch_state(State.POISONED, EnemyStateData.build().with_effect(effect))

func can_take_damage() -> bool:
	return _current_state != null and _current_state.can_take_damage()

func handle_aoe(projectile_stats: ProjectileStats) -> void:
	if _current_state != null:
		_current_state.handle_aoe(projectile_stats)

func handle_bolt(bolt_stats: TowerLevelStats) -> void:
	if _current_state != null:
		_current_state.handle_bolt(bolt_stats)

func handle_damage(amount: float) -> void:
	if _current_state != null:
		_current_state.handle_damage(amount)

func handle_strike(projectile_stats: ProjectileStats) -> void:
	if _current_state != null:
		_current_state.handle_strike(projectile_stats)
