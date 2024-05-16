class_name TowerLevel extends Node2D

@onready var stats: TowerLevelStats = $Stats
@onready var effect_stats: EffectStats = $EffectStats

@export_range(1, 10)
var price: int = 1

signal created_projectile(projectile: Projectile)

func fire():
	try_create_projectile()
	try_create_effect()

func try_create_projectile():
	if not stats.stats_enabled:
		return

	print("Creating projectile")

	var projectile_scene = stats.projectile

	var projectile: Projectile = projectile_scene.instantiate()

	projectile.damage = stats.damage
	projectile.effective_range = stats.projectile_range
	projectile.speed = stats.projectile_speed

	created_projectile.emit(projectile)

func try_create_effect():
	if not effect_stats.stats_enabled:
		return

	# TODO: implement effect
	print("Creating effect")
