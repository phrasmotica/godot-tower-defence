class_name RicochetBulletStateMoving
extends RicochetBulletState

func _enter_tree() -> void:
	_colliders.enemy_hit.connect(handle_enemy_hit)

func _process(_delta: float) -> void:
	_ricochet_bullet.translate(_movement.translate())

	if _movement.is_finished():
		_ricochet_bullet.queue_free()

func handle_collision(enemy: Enemy) -> void:
	handle_enemy_hit(enemy)

func handle_enemy_hit(enemy: Enemy) -> void:
	if _ricochets.try_deduct():
		print("Collided with %s, %d ricochet(s) remaining" % [enemy.name, _ricochets.count()])
		ricochet(enemy)
		return

	print("Freeing after collision with %s, no ricochets remaining" % enemy.name)
	_ricochet_bullet.queue_free()

## Rebound into the given enemy's nearest neighbour.
func ricochet(enemy: Enemy) -> void:
	_ricochet_bullet.projectile_stats.speed = int(_ricochet_bullet.projectile_stats.speed * 0.5)

	var nearest_enemy := EnemyManager.get_neighbour(enemy, 100 * _ricochet_bullet.projectile_stats.effective_range)
	if nearest_enemy:
		print("Ricocheting towards " + nearest_enemy.name)

		var new_direction := _ricochet_bullet.global_position.direction_to(nearest_enemy.global_position)
		_ricochet_bullet.rotation = new_direction.angle()

		_movement.change_direction(new_direction)
	else:
		print("No nearby enemy to ricochet towards!")
