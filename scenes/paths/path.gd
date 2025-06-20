@tool
class_name Path extends Node2D

@export
var tile_map: TileMap

@export
var path_waypoints: Path2D

@export
var start_arrow: Node2D

var original_tile_set: TileSet

func _ready():
	original_tile_set = tile_map.tile_set

func enable_path():
	show()

	if not tile_map.tile_set:
		tile_map.tile_set = original_tile_set

func disable_path():
	hide()

	tile_map.tile_set = null

func start_game():
	start_arrow.hide()

func spawn_enemy(enemy_scene: PackedScene):
	var enemy: Enemy = enemy_scene.instantiate()

	path_waypoints.add_child(enemy)

	return enemy
