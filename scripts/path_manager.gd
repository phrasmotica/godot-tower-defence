class_name PathManager extends Node2D

@export
var paths: Array[Path] = []

@export_range(0, 1)
var initial_path_index := 0

signal enemy_died(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func _ready():
	for i in range(paths.size()):
		if i == initial_path_index:
			paths[i].show()
			paths[i].enemy_died.connect(_on_path_enemy_died)
			paths[i].enemy_reached_end.connect(_on_path_enemy_reached_end)
		else:
			paths[i].hide()

func get_active_path():
	return paths[initial_path_index]

func spawn_enemy(enemy_scene: PackedScene):
	# TODO: do the signal-connecting entirely in this script
	return get_active_path().spawn_enemy(enemy_scene)

func _on_path_enemy_died(enemy: Enemy):
	enemy_died.emit(enemy)

func _on_path_enemy_reached_end(enemy: Enemy):
	enemy_reached_end.emit(enemy)
