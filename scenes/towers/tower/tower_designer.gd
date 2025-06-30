@tool
class_name TowerDesigner
extends Node

@export
var weaponry: TowerWeaponry

signal level_changed(level: TowerLevel)
signal level_projectile_stats_changed(stats: TowerLevelStats)
signal level_effect_stats_changed(stats: EffectStats)

func _ready() -> void:
	if Engine.is_editor_hint():
		weaponry.ready.connect(_setup_design_signals)

func _setup_design_signals() -> void:
	for level in weaponry.get_all_levels():
		level.changed.connect(level_changed.emit.bind(level))
		level.projectile_stats_changed.connect(level_projectile_stats_changed.emit)
		level.effect_stats_changed.connect(level_effect_stats_changed.emit)
