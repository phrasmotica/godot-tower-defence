class_name EnemyStateMoving
extends EnemyState

func _enter_tree() -> void:
	print("%s is now moving" % _info.get_name())

func _process(delta: float) -> void:
	accelerate(delta)
	move(delta)

func can_be_slowed() -> bool:
	return true

func can_be_paralysed() -> bool:
	return true

func can_be_poisoned() -> bool:
	return true
