class_name CannonballStateExploding
extends CannonballState

const EXPLOSION_TIME_PERIOD := 0.1

var _explosion_scene := preload("res://scenes/projectiles/cannonball/explosion.tscn")

func _enter_tree() -> void:
	var enemy := _state_data.get_enemy()

	var explosion: Explosion = _explosion_scene.instantiate()
	explosion.time_period = EXPLOSION_TIME_PERIOD

	explosion.global_position = _cannonball.global_position

	# the unscaled explosion shader has a radius of 200px. So halving its scale
	# means it has the correct radius
	explosion.scale = 0.5 * _cannonball.area_radius * Vector2.ONE

	explosion.tree_exited.connect(_cannonball.queue_free)

	add_child(explosion)

	var neighbours := EnemyManager.get_neighbours(enemy, 100 * _cannonball.area_radius)

	print("Affecting %d neighbour(s) in radius %d" % [neighbours.size(), _cannonball.area_radius])

	for e in neighbours:
		(e as Enemy).handle_aoe(_cannonball)

	_cannonball.sprite.hide()
	_cannonball.collider.set_deferred("disabled", true)
