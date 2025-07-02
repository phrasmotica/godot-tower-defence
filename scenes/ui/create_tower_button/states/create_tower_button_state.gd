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

func resolve_state(old_money: int, new_money: int) -> void:
	var can_no_longer_afford := _button.tower_price <= old_money and _button.tower_price > new_money
	var can_now_afford := _button.tower_price > old_money and _button.tower_price <= new_money

	if can_no_longer_afford:
		transition_state(CreateTowerButton.State.CANNOT_AFFORD)
	elif can_now_afford:
		transition_state(CreateTowerButton.State.ENABLED)
