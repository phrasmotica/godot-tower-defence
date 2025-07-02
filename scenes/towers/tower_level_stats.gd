@tool
class_name TowerLevelStats extends Resource

enum AccuracyProfile { LOW, MEDIUM, HIGH, ULTRA }

var _accuracies := {
	AccuracyProfile.ULTRA: 2.0,
	AccuracyProfile.HIGH: 5.0,
	AccuracyProfile.MEDIUM: 10.0,
	AccuracyProfile.LOW: 20.0,
}

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

@export_range(1.0, 10.0)
var projectile_range := 3.0:
	set(value):
		projectile_range = value

		emit_changed()

@export_range(5, 30)
var projectile_speed: int = 10

@export
var projectile_accuracy := AccuracyProfile.MEDIUM

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

func get_accuracy_variance() -> float:
	return deg_to_rad(_accuracies[projectile_accuracy])
