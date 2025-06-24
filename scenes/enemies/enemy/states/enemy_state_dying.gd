class_name EnemyStateDying
extends EnemyState

func _enter_tree() -> void:
	print("%s is now dying" % _info.get_name())

	EnemyEvents.emit_enemy_died(_enemy)

	# this animation removes the enemy when it ends
	_enemy.animation_player.stop()
	_enemy.animation_player.play("die")
