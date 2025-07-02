class_name ParalyseEffect extends Effect

func _enter_tree() -> void:
	enemy.paralyse(self)

func can_act() -> bool:
	return enemy.can_be_paralysed()
