class_name HealthEnhancement extends WaveEnhancement

## The multiplier to apply to spawned enemies' health.
@export_range(1.0, 10.0)
var health_mult := 1.0

func act(enemy: Enemy) -> void:
    enemy.set_max_health(health_mult * enemy.stats.starting_health)
