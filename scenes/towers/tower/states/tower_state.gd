class_name TowerState
extends Node

signal state_transition_requested(new_state: Tower.State, state_data: TowerStateData)

var _tower: Tower = null
var _state_data: TowerStateData = null
var _appearance: TowerAppearance = null
var _collision_area: Area2D = null
var _selection: TowerSelection = null
var _level_manager: TowerLevelManager = null
var _progress_bars: TowerProgressBars = null
var _path_manager: PathManager = null
var _barrel: GunBarrel = null
var _firing_line: FiringLine = null
var _animation_player: AnimationPlayer = null

func setup(
	tower: Tower,
	state_data: TowerStateData,
	appearance: TowerAppearance,
	collision_area: Area2D,
	level_manager: TowerLevelManager,
	selection: TowerSelection,
	progress_bars: TowerProgressBars,
	path_manager: PathManager,
	barrel: GunBarrel,
	firing_line: FiringLine,
	animation_player: AnimationPlayer,
) -> void:
	_tower = tower
	_state_data = state_data
	_appearance = appearance
	_collision_area = collision_area
	_level_manager = level_manager
	_selection = selection
	_progress_bars = progress_bars
	_path_manager = path_manager
	_barrel = barrel
	_firing_line = firing_line
	_animation_player = animation_player

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
