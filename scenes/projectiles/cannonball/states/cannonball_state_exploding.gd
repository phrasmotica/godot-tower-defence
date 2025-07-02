class_name CannonballStateExploding
extends CannonballState

const EXPLOSION_TIME_PERIOD := 0.1

var _explosion_factory := ExplosionFactory.new(EXPLOSION_TIME_PERIOD)

func _enter_tree() -> void:
	var enemy := _state_data.get_enemy()

	var radius := _cannonball.area_radius
	var explosion: Explosion = _explosion_factory.create(radius)

	explosion.tree_exited.connect(_cannonball.queue_free)

	_appearance.for_explosion(explosion)

	var neighbours := EnemyManager.get_neighbours(enemy, 100 * radius)

	Logger.info("Affecting %d neighbour(s) in radius %d" % [neighbours.size(), radius])

	for e in neighbours:
		e.handle_aoe(_cannonball.projectile_stats)
