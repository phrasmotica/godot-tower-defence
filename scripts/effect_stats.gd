class_name EffectStats extends Node

enum Effect { SLOW, POISON }

@export
var stats_enabled := true

@export
var type := Effect.SLOW

@export_range(1, 5)
var fire_rate: int = 1

@export_range(1, 4)
var effect_range: int = 2
