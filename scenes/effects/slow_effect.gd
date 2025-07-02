class_name SlowEffect extends Effect

func _enter_tree() -> void:
	enemy.slow(self)

func can_act() -> bool:
	return enemy.can_be_slowed()
