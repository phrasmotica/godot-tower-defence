class_name BountyEnhancement extends WaveEnhancement

## The multiplier to apply to spawned enemies' bounties.
@export_range(1.0, 3.0)
var bounty_mult := 1.0

func act(enemy: Enemy) -> void:
	enemy.scale_bounty(bounty_mult)
