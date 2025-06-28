class_name RicochetBulletStateMoving
extends RicochetBulletState

func _process(_delta: float) -> void:
	_ricochet_bullet.translate(_movement.translate())

	if _movement.is_finished():
		_ricochet_bullet.queue_free()

func handle_collision(enemy: Enemy) -> void:
	if _ricochet_bullet.ricochet_count > 0:
		_ricochet_bullet.ricochet_count -= 1
		print("Collided with %s, %d ricochet(s) remaining" % [enemy.name, _ricochet_bullet.ricochet_count])
		ricochet(enemy)
		return

	print("Freeing after collision with %s, no ricochets remaining" % enemy.name)
	_ricochet_bullet.queue_free()

## Rebound into the given enemy's nearest neighbour.
func ricochet(enemy: Enemy) -> void:
	_ricochet_bullet.speed = int(_ricochet_bullet.speed * 0.5)

	var nearest_enemy := EnemyManager.get_neighbour(enemy, 100 * _ricochet_bullet.effective_range)
	if nearest_enemy:
		print("Ricocheting towards " + nearest_enemy.name)

		var new_rotation := _ricochet_bullet.global_position.direction_to(nearest_enemy.global_position)
		_ricochet_bullet.rotation = new_rotation.angle()
		_ricochet_bullet.direction = new_rotation
	else:
		print("No nearby enemy to ricochet towards!")
