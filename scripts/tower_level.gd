class_name TowerLevel extends Node2D

@onready var stats: TowerLevelStats = $Stats
@onready var effect_stats: EffectStats = $EffectStats

@export_multiline
var level_description := ""

@export_range(1, 10)
var price := 1

signal created_projectile(projectile: Projectile)
signal created_effect(effect: Effect)

func get_fire_rate():
	return stats.fire_rate

func get_range(for_effect: bool):
	return effect_stats.effect_range if for_effect else stats.projectile_range

func get_effect_fire_rate():
	return effect_stats.fire_rate

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

	print("Creating effect")

	var effect = effect_stats.create()

	created_effect.emit(effect)
