class_name TowerState
extends Node

signal state_transition_requested(new_state: Tower.State, state_data: TowerStateData)

var _tower: Tower = null
var _state_data: TowerStateData = null
var _collision_area: Area2D = null
var _selection: TowerSelection = null
var _visualiser: TowerVisualiser = null
var _level_manager: TowerLevelManager = null

func setup(
	tower: Tower,
	state_data: TowerStateData,
	collision_area: Area2D,
	level_manager: TowerLevelManager,
	selection: TowerSelection,
	visualiser: TowerVisualiser,
) -> void:
	_tower = tower
	_state_data = state_data
	_collision_area = collision_area
	_level_manager = level_manager
	_selection = selection
	_visualiser = visualiser

func transition_state(
	new_state: Tower.State,
	state_data := TowerStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
