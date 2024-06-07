@tool
class_name TowerLevel extends Node2D

@export_multiline
var level_description := ""

@export_range(1, 10)
var price := 1

@export
var animated_sprite: AnimatedSprite2D

@export
var sprite: SpriteFrames:
	set(value):
		sprite = value
		animated_sprite.sprite_frames = value

@export
var projectile_stats: TowerLevelStats:
	set(value):
		projectile_stats = value

		if projectile_stats and not projectile_stats.adjust_range.is_connected(emit_adjust_range):
			projectile_stats.adjust_range.connect(emit_adjust_range)

@export
var effect_stats: EffectStats:
	set(value):
		effect_stats = value

		if effect_stats and not effect_stats.adjust_range.is_connected(emit_adjust_effect_range):
			effect_stats.adjust_range.connect(emit_adjust_effect_range)

@export
var upgrades: Array[TowerLevel]

## Whether the tower should points towards the targeted enemy.
@export
var point_towards_enemy := true

signal adjust_range(range: float)
signal adjust_effect_range(range: float)

signal created_projectile(projectile: Projectile)
signal created_effect(effect: Effect)
signal created_bolt(bolt_stats: TowerLevelStats)

func get_fire_rate():
	return projectile_stats.fire_rate if projectile_stats else 0.0

func get_range(for_effect: bool):
	if for_effect:
		return effect_stats.effect_range if effect_stats else 0.0

	return projectile_stats.projectile_range if projectile_stats else 0.0

func get_effect_fire_rate():
	return effect_stats.fire_rate if effect_stats else 0

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
	if not projectile_stats:
		return

	print("Creating projectile")

	var projectile_scene = projectile_stats.projectile

	var projectile: Projectile = projectile_scene.instantiate()

	projectile.damage = projectile_stats.damage
	projectile.effective_range = projectile_stats.projectile_range
	projectile.speed = projectile_stats.projectile_speed
	projectile.knockback = projectile_stats.projectile_knockback
	projectile.penetration_count = projectile_stats.penetration_count

	created_projectile.emit(projectile)

func try_create_effect():
	if not effect_stats:
		return

	print("Creating effect")

	var effect = effect_stats.create()

	created_effect.emit(effect)

func try_shoot_bolt():
	print("Shooting a bolt")

	created_bolt.emit(projectile_stats)

func emit_adjust_range(stats_range: float):
	print("Level Stats Range " + str(stats_range))
	adjust_range.emit(stats_range)

func emit_adjust_effect_range(stats_range: float):
	print("Level EffectStats Range " + str(stats_range))
	adjust_effect_range.emit(stats_range)
