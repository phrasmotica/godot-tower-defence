extends Node2D

var path: Path

@onready var firing_line: RayCast2D = $FiringLine

func _process(delta):
	var near_enemy = get_near_enemy()
	if near_enemy:
		point_towards_enemy(near_enemy, delta)

func should_shoot():
	return firing_line.is_colliding()

func get_current_level() -> TowerLevel:
	# firing line is child index 0, so skip it
	return get_child(1)

func get_range_px():
	# 1 range => 100px
	return get_current_level().stats.range * 100

func get_near_enemy():
	var enemies = path.enemies
	if enemies.size() <= 0:
		return null

	if enemies[0] == null or enemies[0].is_queued_for_deletion():
		return null

	var distance_to_enemy = global_position.distance_to(enemies[0].global_position)
	if distance_to_enemy > get_range_px():
		return null

	return enemies[0]

func point_towards_enemy(enemy: Enemy, delta: float):
	var rotate_speed = get_current_level().stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# slowly changes the rotation to face the angle
	rotation = move_toward(rotation, angle_to_enemy, delta * rotate_speed)
