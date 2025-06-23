class_name EnemyStateSlowed
extends EnemyState

func _enter_tree() -> void:
	print("%s is now slowed" % _info.get_name())
