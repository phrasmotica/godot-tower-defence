@tool
class_name Wave
extends Resource

@export_multiline
var description := ""

## The enemy to spawn.
@export
var enemy: PackedScene

## The number of enemies to spawn.
@export_range(1, 40)
var spawn_count := 1

## The number of enemies to spawn each second.
@export_range(1, 10)
var spawn_frequency := 1

## Any enhancements to add to the wave.
@export
var enhancements: Array[WaveEnhancement] = []

var number := 0
