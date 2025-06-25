class_name ProjectileFactory

func create(stats: TowerLevelStats) -> Projectile:
	var projectile: Projectile = stats.projectile.instantiate()

	projectile.damage = stats.damage
	projectile.effective_range = stats.projectile_range
	projectile.speed = stats.projectile_speed
	projectile.knockback = stats.projectile_knockback
	projectile.penetration_count = stats.penetration_count

	return projectile
