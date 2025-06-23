class_name WavesManagerState
extends Node

signal state_transition_requested(new_state: WavesManager.State, state_data: WavesManagerStateData)

var _waves_manager: WavesManager = null
var _state_data: WavesManagerStateData = null

func setup(
	waves_manager: WavesManager,
	state_data: WavesManagerStateData,
) -> void:
	_waves_manager = waves_manager
	_state_data = state_data

func transition_state(
	new_state: WavesManager.State,
	state_data := WavesManagerStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)
