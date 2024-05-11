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

func start_upgrade():
	if not can_upgrade():
		return

	animation_player.play("upgrade")

func upgrade_finished():
	if not can_upgrade():
		return

	level_index += 1

	levels[level_index - 1].visible = false
	levels[level_index].visible = true

	upgraded.emit()

func can_upgrade():
	return level_index < levels.size() - 1

func should_shoot():
	return firing_line.is_colliding()

func get_current_level() -> TowerLevel:
	return levels[level_index]

func point_towards_enemy(enemy: Enemy, delta: float):
	var rotate_speed = get_current_level().stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# slowly changes the rotation to face the angle
	rotation = move_toward(rotation, angle_to_enemy, delta * rotate_speed)
