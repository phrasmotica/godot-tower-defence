extends Node2D

@onready var firing_line: RayCast2D = $FiringLine

func should_shoot():
	return firing_line.is_colliding()

func get_current_level() -> TowerLevel:
	# firing line is child index 0, so skip it
	return get_child(1)

func point_towards_enemy(enemy: Enemy, delta: float):
	var rotate_speed = get_current_level().stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# slowly changes the rotation to face the angle
	rotation = move_toward(rotation, angle_to_enemy, delta * rotate_speed)
