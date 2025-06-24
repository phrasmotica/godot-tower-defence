class_name EnemyStatePoisoned
extends EnemyState

func _enter_tree() -> void:
	print("%s is now poisoned" % _info.get_name())

	var effect := _state_data.get_effect()

	if not effect or effect.effect_duration <= 0:
		print("Effect does nothing!")
		transition_state(Enemy.State.MOVING)

	var animation_speed := 1 / effect.effect_duration

	_enemy.animation_player.play("poison", -1, animation_speed)

	await get_tree().create_timer(effect.effect_duration).timeout

	transition_state(Enemy.State.MOVING)

func _process(delta: float) -> void:
	accelerate(delta)
	move(delta)
