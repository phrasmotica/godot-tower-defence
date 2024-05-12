class_name TowerLevelManager extends Node2D

@onready var firing_line: RayCast2D = $FiringLine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var levels: Array[TowerLevel]

var level_index = 0

signal warmed_up
signal upgraded

func start_warmup():
	animation_player.play("warmup")

func warmup_finished():
	warmed_up.emit()

func start_upgrade() -> TowerLevel:
	var next_level = get_upgrade()

	if next_level:
		animation_player.play("upgrade")

	return next_level

func upgrade_finished():
	if not get_upgrade():
		return

	level_index += 1

	levels[level_index - 1].visible = false
	levels[level_index].visible = true

	upgraded.emit()

func get_upgrade():
	if level_index < levels.size() - 1:
		return levels[level_index + 1]

	return null

func should_shoot():
	return firing_line.is_colliding()

func get_current_level() -> TowerLevel:
	return levels[level_index]

func get_total_value():
	if level_index <= 0 or levels.size() < 2:
		return 0

	# return sum of prices of purchased upgrades
	return (
		levels
			.slice(1, level_index + 1)
			.map(func(level): return level.price)
			.reduce(func(a, b): return a + b)
	)

func point_towards_enemy(enemy: Enemy, delta: float):
	var rotate_speed = get_current_level().stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# slowly changes the rotation to face the angle
	rotation = move_toward(rotation, angle_to_enemy, delta * rotate_speed)
