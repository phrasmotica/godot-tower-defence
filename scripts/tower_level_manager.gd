extends Node2D

@onready var firing_line: RayCast2D = $FiringLine

func should_shoot():
	return firing_line.is_colliding()

func get_current_level() -> TowerLevel:
	# firing line is child index 0, so skip it
	return get_child(1)
