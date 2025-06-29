class_name BulletState
extends Node

signal state_transition_requested(new_state: Bullet.State, state_data: BulletStateData)

var _bullet: Bullet = null
var _state_data: BulletStateData = null
var _movement: ProjectileMovement = null

func setup(
	bullet: Bullet,
	state_data: BulletStateData,
	movement: ProjectileMovement,
) -> void:
	_bullet = bullet
	_state_data = state_data
	_movement = movement

func transition_state(
	new_state: Bullet.State,
	state_data := BulletStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func handle_collision(_enemy: Enemy) -> void:
	pass
