class_name EnemyStats extends Node

@export_range(1.0, 20.0)
var starting_health := 5.0

var current_health: float

func _ready():
    current_health = starting_health

func take_damage(amount: float):
    current_health -= amount
    print("Took " + str(amount) + " damage, health is now " + str(current_health))
    return current_health
