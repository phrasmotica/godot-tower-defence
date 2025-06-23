class_name EnemyStateParalysed
extends EnemyState

func _enter_tree() -> void:
	print("%s is now paralysed" % _info.get_name())
