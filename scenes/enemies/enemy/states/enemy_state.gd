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

func is_upgrading() -> bool:
	return false

func can_be_selected() -> bool:
	return false

func select() -> void:
	_appearance.show_visualiser()
	_appearance.show_range()

	_interaction.show_selection()
	_interaction.set_selected(true)

func deselect() -> void:
	_appearance.hide_visualiser()
	_appearance.hide_range()

	_interaction.hide_selection()
	_interaction.set_selected(false)
