class_name GameUIState
extends Node

signal state_transition_requested(new_state: GameUI.State, state_data: GameUIStateData)

var _game_ui: GameUI = null
var _state_data: GameUIStateData = null
var _create_tower_ui: CreateTowerUI = null
var _tower_ui: TowerUI = null
var _path_manager: PathManager = null

func setup(
	game_ui: GameUI,
	state_data: GameUIStateData,
	tower_ui: TowerUI,
	create_tower_ui: CreateTowerUI,
	path_manager: PathManager,
) -> void:
	_game_ui = game_ui
	_state_data = state_data
	_tower_ui = tower_ui
	_create_tower_ui = create_tower_ui
	_path_manager = path_manager

func transition_state(
	new_state: GameUI.State,
	state_data := GameUIStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
