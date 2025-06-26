class_name TowerAiming

var _tower_position := Vector2.ZERO
var _angle := 0.0

func _init(tower_position: Vector2) -> void:
	_tower_position = tower_position

func point_towards_enemy(rotate_speed: int, enemy: Enemy, delta: float) -> float:
	# gets the angle we want to face
	var angle_to_enemy := _tower_position.direction_to(enemy.global_position).angle()

	# ensure rotation is in the range (-180, 180]
	while angle_to_enemy > PI:
		angle_to_enemy -= (2 * PI)

	# slowly changes the rotation to face the angle
	_angle = rotate_toward(_angle, angle_to_enemy, delta * rotate_speed)
	return _angle
