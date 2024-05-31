@tool
class_name Path extends Node2D

@export
var path_area: Area2D

@export
var path_waypoints: Path2D

var enemies: Array[Enemy] = []

signal enemy_died(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func enable_path():
	show()

	path_area.monitoring = true
	path_area.monitorable = true

func disable_path():
	hide()

	path_area.monitoring = false
	path_area.monitorable = false

func spawn_enemy(enemy_scene: PackedScene):
	var enemy: Enemy = enemy_scene.instantiate()

	enemy.die.connect(_on_enemy_die)
	enemy.reached_end.connect(_on_enemy_reached_end)

	path_waypoints.add_child(enemy)
	enemies.append(enemy)

	return enemy

func remove_enemy(enemy: Enemy):
	enemies.erase(enemy)

func _on_enemy_die(enemy: Enemy):
	remove_enemy(enemy)

	enemy_died.emit(enemy)

func _on_enemy_reached_end(enemy: Enemy):
	remove_enemy(enemy)
	enemy.queue_free()

	enemy_reached_end.emit(enemy)
