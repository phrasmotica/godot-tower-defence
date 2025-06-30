class_name TowerState
extends Node

signal state_transition_requested(new_state: Tower.State, state_data: TowerStateData)

var _tower: Tower = null
var _state_data: TowerStateData = null
var _appearance: TowerAppearance = null
var _colliders: TowerColliders = null
var _info: TowerInfo = null
var _interaction: TowerInteraction = null
var _weaponry: TowerWeaponry = null

var _skip_setup := false

func setup(
	tower: Tower,
	state_data: TowerStateData,
	appearance: TowerAppearance,
	colliders: TowerColliders,
	info: TowerInfo,
	interaction: TowerInteraction,
	weaponry: TowerWeaponry,
) -> void:
	_tower = tower
	_state_data = state_data
	_appearance = appearance
	_colliders = colliders
	_info = info
	_interaction = interaction
	_weaponry = weaponry

func transition_state(
	new_state: Tower.State,
	state_data := TowerStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func skip_setup() -> void:
	_skip_setup = true

func is_upgrading() -> bool:
	return false

func can_be_selected() -> bool:
	return false

func select() -> void:
	_interaction.show_visualiser()
	_interaction.show_range()

	_interaction.show_selection()
	_interaction.set_selected(true)

func deselect() -> void:
	_interaction.hide_visualiser()
	_interaction.hide_range()

	_interaction.hide_selection()
	_interaction.set_selected(false)
