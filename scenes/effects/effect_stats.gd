@tool
class_name EffectStats extends Resource

@export
var stats_enabled := true

@export_range(1, 5)
var fire_rate := 1

@export_range(1.0, 10.0)
var effect_range := 2.0:
	set(value):
		effect_range = value

		# TODO: use emit_changed() instead
		adjust_range.emit(value)

## The length of time that the effect lasts for, in seconds.
@export_range(1.0, 10.0)
var effect_duration := 1.0

@export
var effect: PackedScene

signal adjust_range(stats_range: float)
