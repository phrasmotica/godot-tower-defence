class_name BulletStateMoving
extends BulletState

func _enter_tree() -> void:
	_colliders.enemy_hit.connect(handle_enemy_hit)

func _process(_delta: float) -> void:
	_bullet.translate(_movement.translate())

	if _movement.is_finished():
		_bullet.queue_free()

func handle_collision(enemy: Enemy) -> void:
	handle_enemy_hit(enemy)

func handle_enemy_hit(enemy: Enemy) -> void:
	if _bullet.projectile_stats.penetration_count > 0:
		_bullet.projectile_stats.penetration_count -= 1
		Logger.info("Collided with %s, %d penetration(s) remaining" % [enemy.name, _bullet.projectile_stats.penetration_count])
		return

	Logger.info("Freeing after collision with %s" % enemy.name)
	_bullet.queue_free()
