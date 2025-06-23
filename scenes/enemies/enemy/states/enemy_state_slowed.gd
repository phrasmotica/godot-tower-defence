class_name EnemyStateSlowed
extends EnemyState

func _enter_tree() -> void:
	print("%s is now slowed" % _info.get_name())

	_enemy.current_speed /= 2

	# TODO: get this from state data
	var duration := 3.0

	var animation_speed := 1 / duration

	_enemy.animation_player.play("slow", -1, animation_speed)

	await get_tree().create_timer(duration).timeout

	transition_state(Enemy.State.MOVING)

func _process(delta: float) -> void:
	move(delta)
