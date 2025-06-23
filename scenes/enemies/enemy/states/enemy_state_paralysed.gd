class_name EnemyStateParalysed
extends EnemyState

func _enter_tree() -> void:
	print("%s is now paralysed" % _info.get_name())

	_enemy.current_speed = 0

	# TODO: get this from state data
	var duration := 3.0

	var animation_speed := 1 / duration

	_enemy.animation_player.play("paralyse", -1, animation_speed)

	await get_tree().create_timer(duration).timeout

	transition_state(Enemy.State.MOVING)
