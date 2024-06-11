@tool
class_name EffectStats extends Node

@export
var stats_enabled := true

@export_range(1, 5)
var fire_rate := 1

@export_range(1.0, 10.0)
var effect_range := 2.0:
    set(value):
        effect_range = value
        print("EffectStats Range " + str(value))
        adjust_range.emit(value)

## The length of time that the effect lasts for, in seconds.
@export_range(1.0, 5.0)
var effect_duration := 1.0

@export
var effect: PackedScene

signal adjust_range(stats_range: float)

func create():
    var new_effect: Effect = effect.instantiate()
    new_effect.effect_duration = effect_duration

    add_child(new_effect)

    return new_effect
