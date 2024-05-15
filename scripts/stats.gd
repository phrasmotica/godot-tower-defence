class_name TowerLevelStats extends Node

@export
var projectile: PackedScene

@export_range(1, 3)
var damage: int = 1

@export_range(1, 10)
var fire_rate: int = 1

@export_range(1, 10)
var rotate_speed: int = 3

@export_range(3, 6)
var projectile_range: int = 3

@export_range(5, 30)
var projectile_speed: int = 10
