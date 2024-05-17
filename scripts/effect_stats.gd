class_name EffectStats extends Node

@export
var stats_enabled := true

@export_range(1, 5)
var fire_rate: int = 1

@export_range(1, 4)
var effect_range: int = 2

# TODO: allow setting effect duration

@export
var effect: PackedScene

func create():
    return effect.instantiate()
