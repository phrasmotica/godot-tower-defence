class_name EffectFactory

func create(stats: EffectStats) -> Effect:
	var new_effect: Effect = stats.effect.instantiate()

	new_effect.effect_duration = stats.effect_duration

	return new_effect
