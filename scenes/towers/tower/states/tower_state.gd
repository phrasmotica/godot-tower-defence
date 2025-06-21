class_name TowerState
extends Node

signal state_transition_requested(new_state: Tower.State, state_data: TowerStateData)

var _tower: Tower = null
var _state_data: TowerStateData = null
var _collision_area: Area2D = null
var _selection: TowerSelection = null
var _visualiser: TowerVisualiser = null
var _level_manager: TowerLevelManager = null
var _progress_bars: TowerProgressBars = null
var _path_manager: PathManager = null

func setup(
	tower: Tower,
	state_data: TowerStateData,
	collision_area: Area2D,
	level_manager: TowerLevelManager,
	selection: TowerSelection,
	visualiser: TowerVisualiser,
	progress_bars: TowerProgressBars,
	path_manager: PathManager,
) -> void:
	_tower = tower
	_state_data = state_data
	_collision_area = collision_area
	_level_manager = level_manager
	_selection = selection
	_visualiser = visualiser
	_progress_bars = progress_bars
	_path_manager = path_manager

func transition_state(
	new_state: Tower.State,
	state_data := TowerStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func is_placing() -> bool:
	return false
