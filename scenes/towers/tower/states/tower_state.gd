class_name TowerState
extends Node

signal state_transition_requested(new_state: Tower.State, state_data: TowerStateData)

var _tower: Tower = null
var _state_data: TowerStateData = null
var _appearance: TowerAppearance = null
var _colliders: TowerColliders = null
var _selection: TowerSelection = null
var _weaponry: TowerWeaponry = null
var _path_manager: PathManager = null

func setup(
	tower: Tower,
	state_data: TowerStateData,
	appearance: TowerAppearance,
	colliders: TowerColliders,
	selection: TowerSelection,
	weaponry: TowerWeaponry,
	path_manager: PathManager,
) -> void:
	_tower = tower
	_state_data = state_data
	_appearance = appearance
	_colliders = colliders
	_selection = selection
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
	pass

func deselect() -> void:
	pass
