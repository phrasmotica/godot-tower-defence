class_name EnemyStats extends Node

@export_range(1.0, 20.0)
var starting_health := 5.0

var _current_health: float

func _ready() -> void:
	_current_health = starting_health

func is_alive() -> bool:
	return _current_health > 0

func take_damage(amount: float) -> float:
	_current_health -= amount
	# print("Took " + str(amount) + " damage, health is now " + str(_current_health))
	return _current_health
