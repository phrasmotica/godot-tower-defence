extends Node

const STARTING_LIVES := 10

var current_lives = STARTING_LIVES
var is_dead := false

var _path_manager: PathManager = null

signal lives_changed(new_lives: int)
signal lives_depleted

func _ready() -> void:
	reset_lives()

func setup(path_manager: PathManager) -> void:
	_path_manager = path_manager

	_path_manager.enemy_reached_end.connect(_handle_enemy_reached_end)

func reset_lives() -> void:
	set_lives(STARTING_LIVES)
	print("Resetting to " + str(STARTING_LIVES) + " lives")

func add_lives(amount) -> void:
	set_lives(max(0, current_lives + amount))
	print("Now on " + str(current_lives) + " lives")

func set_lives(lives) -> void:
	current_lives = lives
	lives_changed.emit(current_lives)

	if current_lives <= 0:
		print("Ran out of lives!")
		is_dead = true
		lives_depleted.emit()

func _handle_enemy_reached_end(enemy: Enemy) -> void:
	if is_dead:
		return

	print(enemy.name + " reached end of path")
	add_lives(-1)
