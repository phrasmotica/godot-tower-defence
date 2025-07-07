extends Node

const STARTING_LIVES := 10

var current_lives = STARTING_LIVES
var is_dead := false

signal lives_changed(new_lives: int)
signal lives_depleted

func _ready() -> void:
	EnemyEvents.enemy_reached_end.connect(_handle_enemy_reached_end)

	reset_lives()

func reset_lives() -> void:
	set_lives(STARTING_LIVES)
	Logger.info("Resetting to %d lives" % STARTING_LIVES)

func get_lives() -> int:
	return current_lives

func add_lives(amount) -> void:
	set_lives(max(0, current_lives + amount))
	Logger.debug("Now on %d lives" % current_lives)

func set_lives(lives) -> void:
	current_lives = lives
	lives_changed.emit(current_lives)

	if current_lives <= 0:
		Logger.info("Ran out of lives!")
		is_dead = true
		lives_depleted.emit()

func _handle_enemy_reached_end(enemy: Enemy) -> void:
	if is_dead:
		return

	Logger.debug("%s reached end of path" % enemy.name)
	add_lives(-1)
