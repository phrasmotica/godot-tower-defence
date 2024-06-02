@tool
class_name Path extends Node2D

@export
var tile_map: TileMap

@export
var path_waypoints: Path2D

@export
var start_arrow: Node2D

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

	path_waypoints.add_child(enemy)

	return enemy
