class_name TowerState
extends Node

signal state_transition_requested(new_state: Tower.State, state_data: TowerStateData)

var _tower: Tower = null
var _state_data: TowerStateData = null
var _appearance: TowerAppearance = null
var _colliders: TowerColliders = null
var _interaction: TowerInteraction = null
var _weaponry: TowerWeaponry = null
var _path_manager: PathManager = null

func setup(
	tower: Tower,
	state_data: TowerStateData,
	appearance: TowerAppearance,
	colliders: TowerColliders,
	interaction: TowerInteraction,
	weaponry: TowerWeaponry,
	path_manager: PathManager,
) -> void:
	_tower = tower
	_state_data = state_data
	_appearance = appearance
	_colliders = colliders
	_interaction = interaction
	_weaponry = weaponry
	_path_manager = path_manager

func transition_state(
	new_state: Tower.State,
	state_data := TowerStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func is_upgrading() -> bool:
	return false

func can_be_selected() -> bool:
	return false

func select() -> void:
	_appearance.show_visualiser()
	_appearance.show_range()

	_interaction.set_selected(true)

func deselect() -> void:
	_appearance.hide_visualiser()
	_appearance.hide_range()

	_interaction.set_selected(false)
