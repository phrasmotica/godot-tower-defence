class_name EnemyStatePoisoned
extends EnemyState

func _enter_tree() -> void:
	print("%s is now poisoned" % _info.get_name())

	# TODO: get this from state data
	var duration := 3.0

	var animation_speed := 1 / duration

	_enemy.animation_player.play("poison", -1, animation_speed)

func _process(delta: float) -> void:
	accelerate(delta)
	move(delta)
