class_name EnemyFinder

var enemy_sorter := EnemySorter.new()

var _tower: Tower = null
var _level_manager: TowerLevelManager = null

func _init(
	tower: Tower,
	level_manager: TowerLevelManager,
) -> void:
	_tower = tower
	_level_manager = level_manager

func get_near_enemy(for_effect: bool) -> Enemy:
	var enemies := get_near_enemies(for_effect)
	return enemies[0] if enemies.size() > 0 else null

func get_near_enemies(for_effect: bool) -> Array[Enemy]:
	var enemies = EnemyManager.get_enemies()
	if enemies.size() <= 0:
		return []

	var valid_enemies = enemies.filter(func(e): return e != null and not e.is_queued_for_deletion())
	if valid_enemies.size() <= 0:
		return []

	var shooting_range = get_range_px(for_effect)

	var in_range_enemies = valid_enemies.filter(
		func(e: Enemy) -> bool:
			return e.get_distance_to(_tower.global_position) <= shooting_range
	)

	if in_range_enemies.size() <= 0:
		return []

	match _tower.target_mode:
		Tower.TargetMode.STRONG:
			enemy_sorter.strong(in_range_enemies)
		Tower.TargetMode.FAR:
			enemy_sorter.far(in_range_enemies, _tower.global_position)
		_:
			# nearest enemies first by default
			enemy_sorter.near(in_range_enemies, _tower.global_position)

	return in_range_enemies

func get_range_px(for_effect: bool) -> float:
	var current_level := _level_manager.get_current_level()
	var actual_range := current_level.get_range(for_effect)

	# 1 range => 100px
	return actual_range * 100
