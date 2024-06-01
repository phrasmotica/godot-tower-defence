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

signal enemy_died(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func _ready():
	set_active_path()

func set_active_path():
	print("Setting active path " + str(active_path_index))

	for i in range(paths.size()):
		if i == active_path_index:
			paths[i].enable_path(path_collision_layer)

			if not Engine.is_editor_hint():
				if not paths[i].enemy_died.is_connected(_on_path_enemy_died):
					paths[i].enemy_died.connect(_on_path_enemy_died)

				if not paths[i].enemy_reached_end.is_connected(_on_path_enemy_reached_end):
					paths[i].enemy_reached_end.connect(_on_path_enemy_reached_end)
		else:
			paths[i].disable_path()

func get_active_path():
	return paths[active_path_index]

func spawn_enemy(enemy_scene: PackedScene):
	# TODO: do the signal-connecting entirely in this script
	return get_active_path().spawn_enemy(enemy_scene)

func _on_path_enemy_died(enemy: Enemy):
	enemy_died.emit(enemy)

func _on_path_enemy_reached_end(enemy: Enemy):
	enemy_reached_end.emit(enemy)

func _on_start_game_preview(path_index:int):
	active_path_index = path_index

func _on_start_game_start(path_index: int):
	active_path_index = path_index

	# TODO: instead of hiding the start arrow immediately, only
	# hide it once the first wave has been called
	get_active_path().start_game()
