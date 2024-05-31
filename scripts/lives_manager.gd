extends Node

@export_range(1, 50)
var starting_lives: int

var current_lives = starting_lives

signal lives_changed(new_lives: int)
signal lives_depleted

func _ready():
	reset_lives()

func reset_lives():
	set_lives(starting_lives)
	print("Resetting to " + str(starting_lives) + " lives")

func add_lives(amount):
	set_lives(max(0, current_lives + amount))
	print("Now on " + str(current_lives) + " lives")

func set_lives(lives):
	current_lives = lives
	lives_changed.emit(current_lives)

	if current_lives <= 0:
		print("Ran out of lives!")
		lives_depleted.emit()

func _on_path_manager_enemy_reached_end(enemy: Enemy):
	print(enemy.name + " reached end of path")
	add_lives(-1)
