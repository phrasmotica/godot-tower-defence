@tool
class_name TowerLevel extends Resource

@export
var level_name := ""

@export_multiline
var level_description := ""

@export_range(1, 10)
var price := 1

@export
var sprite: Texture2D:
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

signal projectile_stats_changed(stats: TowerLevelStats)
signal effect_stats_changed(stats: EffectStats)

func _refresh() -> void:
	if projectile_stats and not projectile_stats.changed.is_connected(emit_projectile_stats_changed):
		projectile_stats \
			.changed \
			.connect(emit_projectile_stats_changed)

	if effect_stats and not effect_stats.changed.is_connected(emit_effect_stats_changed):
		effect_stats \
			.changed \
			.connect(emit_effect_stats_changed)

	emit_changed()

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

func get_all_levels() -> Array[TowerLevel]:
	var levels: Array[TowerLevel] = [self]

	for u in upgrades:
		levels.append_array(u.get_all_levels())

	return levels

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

func emit_projectile_stats_changed() -> void:
	projectile_stats_changed.emit(projectile_stats)

func emit_effect_stats_changed() -> void:
	effect_stats_changed.emit(effect_stats)
