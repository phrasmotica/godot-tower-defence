class_name SpeedEnhancement extends WaveEnhancement

## The multiplier to apply to spawned enemies' maximum speed.
@export_range(1.0, 2.0)
var speed_mult := 1.0

func act(enemy: Enemy) -> void:
	enemy.scale_base_speed(speed_mult)
