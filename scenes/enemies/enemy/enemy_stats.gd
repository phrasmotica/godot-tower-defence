class_name EnemyStats extends Node

@export_range(1.0, 20.0)
var starting_health := 5.0

# BUG: this is accessed as "current_health" in a few places. Fix those
var _current_health: float

func _ready() -> void:
	_current_health = starting_health

func take_damage(amount: float) -> float:
	_current_health -= amount
	return _current_health
