class_name ProjectileArea2D
extends Area2D

var _parent_projectile: Projectile = null

func setup(projectile: Projectile) -> void:
	_parent_projectile = projectile

func get_projectile() -> Projectile:
	return _parent_projectile
