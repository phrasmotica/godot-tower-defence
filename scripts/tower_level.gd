class_name TowerLevel extends Node2D

@onready var stats: TowerLevelStats = $Stats

@export_range(1, 10)
var price: int = 1

signal created_projectile(projectile: Projectile)

func fire():
	if not stats.stats_enabled:
		return

	print("Creating projectile")

	var projectile_scene = stats.projectile

	var projectile: Projectile = projectile_scene.instantiate()

	projectile.damage = stats.damage
	projectile.effective_range = stats.projectile_range
	projectile.speed = stats.projectile_speed

	created_projectile.emit(projectile)
