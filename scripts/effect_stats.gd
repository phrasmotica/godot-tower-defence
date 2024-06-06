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

    add_child(new_effect)

    # TODO: this should really be done by the tower object, rather than relying
    # on there being no further updates in between this call and the tower script
    # starting the effect
    new_effect.set_timer(effect_duration)

    return new_effect
