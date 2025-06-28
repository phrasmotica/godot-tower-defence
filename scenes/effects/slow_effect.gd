class_name SlowEffect extends Effect

func _enter_tree() -> void:
	# print("Slowing enemy START")

	enemy.slow(self)

func _exit_tree() -> void:
	# print("Slowing enemy END")
	pass

func can_act() -> bool:
	return enemy.can_be_slowed()
