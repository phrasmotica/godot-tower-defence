extends Node

signal mouse_over_path_area_changed(is_over: bool)

func emit_mouse_over_path_area_changed(is_over: bool) -> void:
	mouse_over_path_area_changed.emit(is_over)
