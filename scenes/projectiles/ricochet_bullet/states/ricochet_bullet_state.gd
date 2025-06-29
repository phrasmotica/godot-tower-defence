class_name RicochetBulletState
extends Node

signal state_transition_requested(new_state: RicochetBullet.State, state_data: RicochetBulletStateData)

var _ricochet_bullet: RicochetBullet = null
var _state_data: RicochetBulletStateData = null
var _colliders: ProjectileColliders = null
var _movement: ProjectileMovement = null

func setup(
	ricochetBullet: RicochetBullet,
	state_data: RicochetBulletStateData,
	colliders: ProjectileColliders,
	movement: ProjectileMovement,
) -> void:
	_ricochet_bullet = ricochetBullet
	_state_data = state_data
	_colliders = colliders
	_movement = movement

func transition_state(
	new_state: RicochetBullet.State,
	state_data := RicochetBulletStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func handle_collision(_enemy: Enemy) -> void:
	pass
