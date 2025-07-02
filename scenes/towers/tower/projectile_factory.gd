class_name ProjectileFactory

func create(stats: TowerLevelStats, rotation: float) -> Node2D:
	var projectile_stats := ProjectileStats.new()

	var variance := stats.get_accuracy_variance() * (randf() - 0.5)
	var aim_direction := Vector2.RIGHT.rotated(rotation).rotated(variance)

	projectile_stats.damage = stats.damage
	projectile_stats.effective_range = stats.projectile_range
	projectile_stats.direction = aim_direction
	projectile_stats.speed = stats.projectile_speed
	projectile_stats.knockback = stats.projectile_knockback
	projectile_stats.penetration_count = stats.penetration_count

	var projectile: Node2D = stats.projectile.instantiate()

	# a fairly harmless way of insisting the new object is a projectile...?
	projectile.projectile_stats = projectile_stats
	assert(projectile.projectile_stats)

	projectile.rotation = aim_direction.angle()

	return projectile
