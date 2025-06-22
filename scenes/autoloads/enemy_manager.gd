extends Node

var _enemies: Array[Enemy] = []

func add_enemy(enemy: Enemy) -> void:
	_enemies.append(enemy)

func remove_enemy(enemy: Enemy) -> void:
	_enemies.erase(enemy)

func get_enemies() -> Array[Enemy]:
	return _enemies

func spawn_enemy(enemy_scene: PackedScene) -> Enemy:
	var enemy: Enemy = enemy_scene.instantiate()

	enemy.die.connect(_on_enemy_die)
	enemy.reached_end.connect(_on_enemy_reached_end)

	add_enemy(enemy)

	EnemyEvents.emit_enemy_spawned(enemy)

	return enemy

func _on_enemy_die(enemy: Enemy) -> void:
	remove_enemy(enemy)

	EnemyEvents.emit_enemy_died(enemy)

func _on_enemy_reached_end(enemy: Enemy) -> void:
	remove_enemy(enemy)

	enemy.queue_free()

	EnemyEvents.emit_enemy_reached_end(enemy)

