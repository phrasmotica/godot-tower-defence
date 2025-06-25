@tool
class_name TowerLevelManager extends Node2D

const normal_colour := Color.WHITE

@export
var progress_colour := Color8(255, 255, 255, 80)

@export
var base_level: TowerLevel

var upgrade_path: Array[int] = []

var ongoing_upgrade_index := -1

func start_upgrade(index: int) -> TowerLevel:
	var next_level := get_upgrade(index)

	if next_level:
		ongoing_upgrade_index = index

	return next_level

func finish_upgrade() -> TowerLevel:
	if ongoing_upgrade_index < 0 or not get_upgrade(ongoing_upgrade_index):
		return

	upgrade_path.append(ongoing_upgrade_index)
	ongoing_upgrade_index = -1

	return get_current_level()

func get_upgrade(index: int) -> TowerLevel:
	return base_level.get_upgrade(upgrade_path, index)

func get_current_level() -> TowerLevel:
	return base_level.get_current_level(upgrade_path)

func get_all_levels() -> Array[TowerLevel]:
	return base_level.get_all_levels()

func get_total_value() -> int:
	return base_level.get_total_value(upgrade_path)

# TODO: compute the current aiming direction in TowerWeaponry instead
func point_towards_enemy(enemy: Enemy, delta: float):
	var current_level := get_current_level()
	if not current_level.point_towards_enemy:
		return

	var rotate_speed = current_level.projectile_stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# ensure rotation is in the range (-180, 180]
	while angle_to_enemy > PI:
		angle_to_enemy -= (2 * PI)

	# slowly changes the rotation to face the angle
	var new_rotation = rotate_toward(rotation, angle_to_enemy, delta * rotate_speed)
	rotation = new_rotation
