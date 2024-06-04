@tool
class_name PathManager extends Node2D

@export
var paths: Array[Path] = []

@export
var active_path_index: int:
	set(value):
		if Engine.is_editor_hint():
			if value < 0 or value > paths.size() - 1:
				return

		active_path_index = value
		set_active_path()

## The collision layer for the path tilesets.
@export_flags_2d_physics
var path_collision_layer := 4

var enemies: Array[Enemy] = []

signal enemy_died(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func _ready():
	set_active_path()

func set_active_path():
	print("Setting active path " + str(active_path_index))

	for i in range(paths.size()):
		if i == active_path_index:
			paths[i].enable_path(path_collision_layer)
		else:
			paths[i].disable_path()

func get_active_path():
	return paths[active_path_index]

func spawn_enemy(enemy_scene: PackedScene):
	var enemy = get_active_path().spawn_enemy(enemy_scene)

	enemy.die.connect(_on_enemy_die)
	enemy.reached_end.connect(_on_enemy_reached_end)

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

func _on_start_game_preview(path_index:int):
	active_path_index = path_index

func _on_start_game_start(path_index: int):
	active_path_index = path_index

func _on_waves_manager_waves_began():
	get_active_path().start_game()