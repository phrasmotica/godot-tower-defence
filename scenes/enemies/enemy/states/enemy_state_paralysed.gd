class_name EnemyStateParalysed
extends EnemyState

func _enter_tree() -> void:
	Logger.info("%s is now paralysed" % _info.get_name())

	var effect := _state_data.get_effect()

	if not effect or effect.effect_duration <= 0:
		Logger.warning("Effect does nothing!")
		transition_state(Enemy.State.MOVING)

	_movement.halt()

	var animation_speed := 1 / effect.effect_duration

	_appearance.animate_paralyse(animation_speed)

	await get_tree().create_timer(effect.effect_duration).timeout

	transition_state(Enemy.State.MOVING)
