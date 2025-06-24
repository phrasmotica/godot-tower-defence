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

func _on_enemy_died(enemy: Enemy) -> void:
	remove_enemy(enemy)

func _on_enemy_reached_end(enemy: Enemy) -> void:
	remove_enemy(enemy)

	enemy.queue_free()
