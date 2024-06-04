@tool
class_name TowerLevel extends Node2D

@onready var stats: TowerLevelStats = $Stats
@onready var effect_stats: EffectStats = $EffectStats

@export_multiline
var level_description := ""

@export_range(1, 10)
var price := 1

@export
var upgrades: Array[TowerLevel]

## Whether the tower should points towards the targeted enemy.
@export
var point_towards_enemy := true

signal adjust_range(range: int)
signal adjust_effect_range(range: int)

signal created_projectile(projectile: Projectile)
signal created_effect(effect: Effect)
signal created_bolt(bolt_stats: TowerLevelStats)

func get_fire_rate():
	return stats.fire_rate

func get_range(for_effect: bool):
	return effect_stats.effect_range if for_effect else stats.projectile_range

func get_effect_fire_rate():
	return effect_stats.fire_rate

func get_current_level(path: Array[int]) -> TowerLevel:
	if path.size() <= 0:
		return self

	return upgrades[path[0]].get_current_level(path.slice(1))

func get_upgrade(path: Array[int], index: int) -> TowerLevel:
	if path.size() <= 0:
		if upgrades.size() <= 0:
			return null

		if upgrades.size() <= index:
			return null

		return upgrades[index]

	return upgrades[path[0]].get_upgrade(path.slice(1), index)

func get_total_value(path: Array[int]) -> int:
	if path.size() <= 0:
		return price

	return price + (
		upgrades[path[0]].get_total_value(path.slice(1))
	)

func try_create_projectile():
	if not stats.stats_enabled:
		return

	print("Creating projectile")

	var projectile_scene = stats.projectile

	var projectile: Projectile = projectile_scene.instantiate()

	projectile.damage = stats.damage
	projectile.effective_range = stats.projectile_range
	projectile.speed = stats.projectile_speed
	projectile.knockback = stats.projectile_knockback
	projectile.penetration_count = stats.penetration_count

	created_projectile.emit(projectile)

func try_create_effect():
	if not effect_stats.stats_enabled:
		return

	print("Creating effect")

	var effect = effect_stats.create()

	created_effect.emit(effect)

func try_shoot_bolt():
	print("Shooting a bolt")

	created_bolt.emit(stats)

func _on_stats_adjust_range(stats_range: int):
	print("Level Stats Range " + str(stats_range))
	adjust_range.emit(stats_range)

func _on_effect_stats_adjust_range(stats_range: int):
	print("Level EffectStats Range " + str(stats_range))
	adjust_effect_range.emit(stats_range)
