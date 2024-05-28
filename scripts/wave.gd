class_name Wave extends Resource

## The enemy to spawn.
@export
var enemy: PackedScene

## The number of enemies to spawn.
@export_range(1, 40)
var spawn_count := 1

## The number of enemies to spawn each second.
@export_range(1, 10)
var spawn_frequency := 1
