class_name EnemyState
extends Node

signal state_transition_requested(new_state: Enemy.State, state_data: EnemyStateData)

var _enemy: Enemy = null
var _state_data: EnemyStateData = null
var _appearance: EnemyAppearance = null
var _colliders: EnemyColliders = null
var _info: EnemyInfo = null
var _interaction: EnemyInteraction = null

func setup(
	enemy: Enemy,
	state_data: EnemyStateData,
	appearance: EnemyAppearance,
	colliders: EnemyColliders,
	info: EnemyInfo,
	interaction: EnemyInteraction,
) -> void:
	_enemy = enemy
	_state_data = state_data
	_appearance = appearance
	_colliders = colliders
	_info = info
	_interaction = interaction

func transition_state(
	new_state: Enemy.State,
	state_data := EnemyStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func accelerate(delta: float) -> void:
	if _enemy.current_speed < _enemy.movement_speed:
		_enemy.current_speed = move_toward(_enemy.current_speed, _enemy.movement_speed, delta * _enemy.movement_speed)

func move(delta: float) -> void:
	if _enemy.progress_ratio < 1.0:
		_enemy.progress += _enemy.current_speed * delta
	else:
		EnemyEvents.emit_enemy_reached_end(_enemy)

func can_be_slowed() -> bool:
	return false

func can_be_paralysed() -> bool:
	return false

func can_be_poisoned() -> bool:
	return false
