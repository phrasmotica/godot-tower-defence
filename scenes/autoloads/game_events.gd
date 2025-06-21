extends Node

signal path_previewed(path_index: int)
signal game_started(path_index: int)

func emit_path_previewed(path_index: int) -> void:
	path_previewed.emit(path_index)

func emit_game_started(path_index: int) -> void:
	game_started.emit(path_index)
