extends Node2D

func get_current_level() -> TowerLevel:
	return get_child(0)
