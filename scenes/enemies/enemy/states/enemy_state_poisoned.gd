class_name EnemyStatePoisoned
extends EnemyState

func _enter_tree() -> void:
	print("%s is now poisoned" % _info.get_name())
