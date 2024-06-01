@tool
class_name Path extends Node2D

@export
var tile_map: TileMap

@export
var path_waypoints: Path2D

@export
var start_arrow: Node2D

var enemies: Array[Enemy] = []

signal enemy_died(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func enable_path(collision_layer: int):
	show()

	tile_map.tile_set.set_physics_layer_collision_layer(0, collision_layer)

func disable_path():
	hide()

	tile_map.tile_set.set_physics_layer_collision_layer(0, 0)

func start_game():
	start_arrow.hide()

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
