class_name PathManager extends Node2D

@export
var paths: Array[Path] = []

signal enemy_died(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func _ready():
	for i in range(paths.size()):
		if i == 0:
			paths[i].show()
			paths[i].enemy_died.connect(_on_path_enemy_died)
			paths[i].enemy_reached_end.connect(_on_path_enemy_reached_end)
		else:
			paths[i].hide()

func get_active_path():
	return paths[0]

func spawn_enemy(enemy_scene: PackedScene):
	# TODO: do the signal-connecting entirely in this script
	return get_active_path().spawn_enemy(enemy_scene)

func _on_path_enemy_died(enemy: Enemy):
	enemy_died.emit(enemy)

func _on_path_enemy_reached_end(enemy: Enemy):
	enemy_reached_end.emit(enemy)
