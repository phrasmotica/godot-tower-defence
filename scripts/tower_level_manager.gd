extends Node2D

func get_current_level() -> TowerLevel:
	# firing line is child index 0, so skip it
	return get_child(1)
