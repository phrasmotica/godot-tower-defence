class_name EnemyStateSlowed
extends EnemyState

func _enter_tree() -> void:
	Logger.info("%s is now slowed" % _info.get_name())

	var effect := _state_data.get_effect()

	if not effect or effect.effect_duration <= 0:
		Logger.info("Effect does nothing!")
		transition_state(Enemy.State.MOVING)

	_movement.slow(2)

	var animation_speed := 1 / effect.effect_duration

	_appearance.animate_slow(animation_speed)

	await get_tree().create_timer(effect.effect_duration).timeout

	transition_state(Enemy.State.MOVING)

func _process(delta: float) -> void:
	move(delta)
