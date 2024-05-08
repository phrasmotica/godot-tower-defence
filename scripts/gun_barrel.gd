class_name GunBarrel extends Node2D

@export var projectile: PackedScene

func _on_shot_timer_timeout():
	var bullet = projectile.instantiate()
	add_child(bullet)
