class_name TowerLevelStats extends Node

@export
var projectile: PackedScene

@export_range(1, 3)
var damage: int = 1

@export_range(1, 2)
var fire_rate: int = 1

@export_range(3, 6)
var range: int = 3
