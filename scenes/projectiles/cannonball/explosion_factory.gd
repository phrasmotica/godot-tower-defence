class_name ExplosionFactory

var _explosion_scene := preload("res://scenes/projectiles/cannonball/explosion.tscn")

var _time_period := 0.0

func _init(time_period: float) -> void:
	_time_period = time_period

func create(radius: int) -> Explosion:
	var explosion: Explosion = _explosion_scene.instantiate()
	explosion.time_period = _time_period

	# the unscaled explosion shader has a radius of 200px. So halving its scale
	# means it has the correct radius
	explosion.scale = 0.5 * radius * Vector2.ONE

	return explosion
