class_name EnemyStateMoving
extends EnemyState

func _enter_tree() -> void:
	print("%s is now moving" % _info.get_name())
