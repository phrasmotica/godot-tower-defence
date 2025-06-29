class_name CannonballState
extends Node

signal state_transition_requested(new_state: Cannonball.State, state_data: CannonballStateData)

var _cannonball: Cannonball = null
var _state_data: CannonballStateData = null
var _appearance: CannonballAppearance = null
var _colliders: ProjectileColliders = null
var _movement: ProjectileMovement = null

func setup(
	cannonball: Cannonball,
	state_data: CannonballStateData,
	appearance: CannonballAppearance,
	colliders: ProjectileColliders,
	movement: ProjectileMovement,
) -> void:
	_cannonball = cannonball
	_state_data = state_data
	_appearance = appearance
	_colliders = colliders
	_movement = movement

func transition_state(
	new_state: Cannonball.State,
	state_data := CannonballStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func handle_collision(_enemy: Enemy) -> void:
	pass
