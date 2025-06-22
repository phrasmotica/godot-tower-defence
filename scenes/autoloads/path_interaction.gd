extends Node

signal mouse_validity_changed(is_valid: bool)
signal valid_area_clicked

func emit_mouse_validity_changed(is_valid: bool) -> void:
	mouse_validity_changed.emit(is_valid)

func emit_valid_area_clicked() -> void:
	valid_area_clicked.emit()
