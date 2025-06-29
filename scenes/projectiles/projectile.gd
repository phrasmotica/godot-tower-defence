class_name Projectile extends Node2D

var damage := 1
var speed := 10
var knockback := 0.0
var penetration_count := 0

var direction: Vector2
var effective_range: float

func handle_collision(_enemy: Enemy) -> void:
	pass
