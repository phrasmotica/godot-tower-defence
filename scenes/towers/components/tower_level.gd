@tool
class_name TowerLevel extends Node2D

@export
var level_name := ""

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

		_refresh()

@export
var projectile_stats: TowerLevelStats:
	set(value):
		projectile_stats = value

		_refresh()

@export
var effect_stats: EffectStats:
	set(value):
		effect_stats = value

		_refresh()

@export
var upgrades: Array[TowerLevel]

## Whether the tower should points towards the targeted enemy.
@export
var point_towards_enemy := true

signal adjust_range(range: float)
signal adjust_effect_range(range: float)

signal created_bolt(bolt_stats: TowerLevelStats)

func _refresh() -> void:
	animated_sprite.sprite_frames = sprite

	if projectile_stats and not projectile_stats.adjust_range.is_connected(emit_adjust_range):
		projectile_stats.adjust_range.connect(emit_adjust_range)

	if effect_stats and not effect_stats.adjust_range.is_connected(emit_adjust_effect_range):
		effect_stats.adjust_range.connect(emit_adjust_effect_range)

func get_fire_rate():
	return projectile_stats.fire_rate if projectile_stats else 0.0

func get_range(for_effect: bool) -> float:
	if for_effect and effect_stats:
		return effect_stats.effect_range

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

func try_shoot_bolt():
	print("Shooting a bolt")

	created_bolt.emit(projectile_stats)

func emit_adjust_range(stats_range: float) -> void:
	adjust_range.emit(stats_range)

func emit_adjust_effect_range(stats_range: float) -> void:
	adjust_effect_range.emit(stats_range)
