class_name UpgradeTowerButtonState
extends Node

signal state_transition_requested(new_state: UpgradeTowerButton.State, state_data: UpgradeTowerButtonStateData)

var _button: UpgradeTowerButton = null
var _state_data: UpgradeTowerButtonStateData = null

func setup(
	button: UpgradeTowerButton,
	state_data: UpgradeTowerButtonStateData,
) -> void:
	_button = button
	_state_data = state_data

func transition_state(
	new_state: UpgradeTowerButton.State,
	state_data := UpgradeTowerButtonStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
