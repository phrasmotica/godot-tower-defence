class_name ParalyseEffect extends Effect

func _enter_tree() -> void:
	# print("Paralysing enemies START")

	enemy.paralyse(self)

func _exit_tree() -> void:
	# print("Paralysing enemies END")
	pass

func can_act() -> bool:
	return enemy.can_be_paralysed()
