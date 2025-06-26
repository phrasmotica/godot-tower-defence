class_name ProjectileContainer
extends Node2D

func spawn_projectile(projectile: Projectile) -> void:
	add_child(projectile)

func spawn_bolt(bolt_line: BoltLine) -> void:
	add_child(bolt_line)
