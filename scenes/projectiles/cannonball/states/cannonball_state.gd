class_name CannonballState
extends Node

signal state_transition_requested(new_state: Cannonball.State, state_data: CannonballStateData)

var _cannonball: Cannonball = null
var _state_data: CannonballStateData = null

func setup(
	cannonball: Cannonball,
	state_data: CannonballStateData,
) -> void:
	_cannonball = cannonball
	_state_data = state_data
func transition_state(
	new_state: Cannonball.State,
	state_data := CannonballStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func handle_collision(_enemy: Enemy) -> void:
	pass
