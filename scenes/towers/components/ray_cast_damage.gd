class_name RayCastDamage extends Node

func process_enemies(ray_cast: RayCast2D, bolt_stats: TowerLevelStats):
	var enemy_collider = ray_cast.get_collider()

	if bolt_stats.infinite_penetration:
		while enemy_collider != null:
			enemy_collider = process_enemy(ray_cast, enemy_collider, bolt_stats)
	elif bolt_stats.penetration_count > 0:
		for i in range(bolt_stats.penetration_count + 1):
			if enemy_collider != null:
				print("Ray cast penetrating enemy " + str(i))
				enemy_collider = process_enemy(ray_cast, enemy_collider, bolt_stats)
	else:
		process_enemy(ray_cast, enemy_collider, bolt_stats)

	ray_cast.clear_exceptions()

func process_enemy(ray_cast: RayCast2D, enemy_collider: CollisionObject2D, bolt_stats: TowerLevelStats):
	# this is not great. Perhaps we should create a special type of Area2D
	# that can emit a signal with the bolt stats?
	var enemy := (enemy_collider as Area2D).find_parent("Enemy*") as Enemy

	enemy.handle_bolt(bolt_stats)

	ray_cast.add_exception(enemy_collider)
	ray_cast.force_raycast_update()

	return ray_cast.get_collider()
