@tool
class_name TowerLevelStats extends Node

@export
var stats_enabled := true

@export
var projectile: PackedScene

@export_range(1, 5)
var damage: int = 1

@export_range(0.1, 10)
var fire_rate := 1.0

@export_range(1, 10)
var rotate_speed: int = 3

@export_range(3, 6)
var projectile_range: int = 3:
    set(value):
        projectile_range = value
        print("Stats Range " + str(value))
        adjust_range.emit(value)

@export_range(5, 30)
var projectile_speed: int = 10

## The amount by which the struck enemy's movement speed should be reduced by
## (0 = no reduction, 100 = completely stop the enemy)
@export_range(0.0, 100.0)
var projectile_knockback := 0.0

## Whether the projectile will survive all collisions with enemies it.
## Enabling will cause the penetration_count setting to be ignored.
@export
var infinite_penetration := false

## How many collisions with enemies the projectile will survive.
@export
var penetration_count := 0

signal adjust_range(stats_range: int)
