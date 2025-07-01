class_name CreateTowerButtonState
extends Node

signal state_transition_requested(new_state: CreateTowerButton.State, state_data: CreateTowerButtonStateData)

var _button: CreateTowerButton = null
var _state_data: CreateTowerButtonStateData = null

func setup(
	button: CreateTowerButton,
	state_data: CreateTowerButtonStateData,
) -> void:
	_button = button
	_state_data = state_data

func transition_state(
	new_state: CreateTowerButton.State,
	state_data := CreateTowerButtonStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
