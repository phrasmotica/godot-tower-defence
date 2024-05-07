class_name EnemyStats extends Node

@export_range(1, 5)
var starting_health: int

var current_health: int

func _ready():
    current_health = starting_health

func take_damage(amount: int):
    current_health -= amount
    print("Took " + str(amount) + " damage, health is now " + str(current_health))
    return current_health
