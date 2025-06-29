class_name ProjectileMovement
extends Node

var _direction: Vector2
var _effective_range: float
var _speed: int

var _distance_travelled: float

func _init(
	direction: Vector2,
	effective_range: float,
	speed: int,
) -> void:
	_direction = direction
	_effective_range = effective_range
	_speed = speed

func translate() -> Vector2:
	var translation := _speed * _direction

	_distance_travelled += translation.length()

	return translation

func is_finished() -> bool:
	# _effective_range is not yet in pixels, so scale it up
	return _distance_travelled >= 100 * _effective_range

func change_direction(direction: Vector2) -> void:
	_direction = direction
