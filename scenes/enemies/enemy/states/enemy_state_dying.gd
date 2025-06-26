class_name EnemyStateDying
extends EnemyState

func _enter_tree() -> void:
	print("%s is now dying" % _info.get_name())

	EnemyEvents.emit_enemy_died(_enemy)

	_appearance.animate_die()

func can_take_damage() -> bool:
	return false
