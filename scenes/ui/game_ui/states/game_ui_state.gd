class_name GameUIState
extends Node

signal state_transition_requested(new_state: GameUI.State, state_data: GameUIStateData)

var _game_ui: GameUI = null
var _state_data: GameUIStateData = null
var _appearance: GameUIAppearance = null

func setup(
	game_ui: GameUI,
	state_data: GameUIStateData,
	appearance: GameUIAppearance,
) -> void:
	_game_ui = game_ui
	_state_data = state_data
	_appearance = appearance

func transition_state(
	new_state: GameUI.State,
	state_data := GameUIStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
