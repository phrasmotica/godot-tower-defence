@tool
class_name TowerLevelManager
extends Node

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
