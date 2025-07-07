class_name EnemyStats extends Node

@export_range(1.0, 20.0)
var starting_health := 5.0

var _current_health: float

func _ready() -> void:
	_current_health = starting_health

func get_current_health() -> float:
	return _current_health

func set_current_health(amount: float) -> void:
	_current_health = amount

func take_damage(amount: float) -> float:
	_current_health -= amount
	return _current_health
