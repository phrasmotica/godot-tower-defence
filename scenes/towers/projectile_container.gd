class_name ProjectileContainer
extends Node2D

func spawn_projectile(projectile: Projectile) -> void:
	add_child(projectile)
