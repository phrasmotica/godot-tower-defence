extends Node

var _enemies: Array[Enemy] = []

func _ready() -> void:
	EnemyEvents.enemy_died.connect(_on_enemy_died)
	EnemyEvents.enemy_reached_end.connect(_on_enemy_reached_end)

func add_enemy(enemy: Enemy) -> void:
	_enemies.append(enemy)

func remove_enemy(enemy: Enemy) -> void:
	_enemies.erase(enemy)

func get_enemies() -> Array[Enemy]:
	return _enemies

func spawn_enemy(enemy_scene: PackedScene) -> Enemy:
	var enemy: Enemy = enemy_scene.instantiate()

	add_enemy(enemy)

	EnemyEvents.emit_enemy_spawned(enemy)

	return enemy

func get_neighbours(originator: Enemy, max_distance_px: float) -> Array[Enemy]:
	if _enemies.size() <= 0:
		return []

	var neighbours := _enemies.filter(
		func(e: Enemy) -> bool:
			if e == originator:
				return false

			return originator.global_position.distance_to(e.global_position) <= max_distance_px
	)

	return neighbours

func get_neighbour(originator: Enemy, max_distance_px: float) -> Enemy:
	var nearby_enemies := get_neighbours(originator, max_distance_px)
	if nearby_enemies.size() <= 0:
		return null

	# nearest enemies first
	nearby_enemies.sort_custom(
		func(e: Enemy, f: Enemy) -> bool:
			var dist1 := e.global_position.distance_to(originator.global_position)
			var dist2 := f.global_position.distance_to(originator.global_position)

			return dist1 < dist2
	)

	return nearby_enemies[0]

func _on_enemy_died(enemy: Enemy) -> void:
	remove_enemy(enemy)

func _on_enemy_reached_end(enemy: Enemy) -> void:
	remove_enemy(enemy)

	enemy.queue_free()
