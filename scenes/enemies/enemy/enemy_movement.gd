class_name EnemyMovement
extends Node

var _base_speed := 0.0
var _current_speed := 0.0

func set_base_speed(base_speed: float) -> void:
	_base_speed = base_speed

func scale_base_speed(factor: float) -> void:
	_base_speed *= factor

func get_base_speed() -> float:
	return _base_speed

func get_current_speed() -> float:
	return _current_speed

func accelerate(delta: float) -> void:
	if _current_speed < _base_speed:
		_current_speed = move_toward(_current_speed, _base_speed, delta * _base_speed)

func slow(factor: float) -> void:
	_current_speed /= factor

func halt() -> void:
	_current_speed = 0

func knockback(knockback_factor: float) -> void:
	Logger.info("Knocking enemy back by factor of %.1f" % knockback_factor)
	_current_speed = _current_speed * (1 - (knockback_factor / 100.0))
