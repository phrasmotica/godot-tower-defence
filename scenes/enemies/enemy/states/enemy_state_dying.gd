class_name EnemyStateDying
extends EnemyState

func _enter_tree() -> void:
	print("%s is now dying" % _info.get_name())
