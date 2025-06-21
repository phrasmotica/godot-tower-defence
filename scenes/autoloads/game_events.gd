extends Node

signal game_started(path_index: int)

func emit_game_started(path_index: int) -> void:
	game_started.emit(path_index)
