class_name ProjectileArea2D
extends Area2D

var _stats: ProjectileStats = null

func setup(stats: ProjectileStats) -> void:
	_stats = stats

func get_projectile_stats() -> ProjectileStats:
	return _stats
