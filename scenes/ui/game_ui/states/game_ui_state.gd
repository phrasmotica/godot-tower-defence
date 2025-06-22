class_name GameUIState
extends Node

signal state_transition_requested(new_state: GameUI.State, state_data: GameUIStateData)

var _game_ui: GameUI = null
var _state_data: GameUIStateData = null
var _appearance: GameUIAppearance = null
var _create_tower_ui: CreateTowerUI = null
var _tower_ui: TowerUI = null

func setup(
	game_ui: GameUI,
	state_data: GameUIStateData,
	appearance: GameUIAppearance,
	tower_ui: TowerUI,
	create_tower_ui: CreateTowerUI,
) -> void:
	_game_ui = game_ui
	_state_data = state_data
	_appearance = appearance
	_tower_ui = tower_ui
	_create_tower_ui = create_tower_ui

func transition_state(
	new_state: GameUI.State,
	state_data := GameUIStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
