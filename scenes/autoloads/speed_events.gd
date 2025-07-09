extends Node

signal speed_fast_requested
signal speed_normal_requested

func emit_speed_fast_requested() -> void:
	speed_fast_requested.emit()

func emit_speed_normal_requested() -> void:
	speed_normal_requested.emit()
