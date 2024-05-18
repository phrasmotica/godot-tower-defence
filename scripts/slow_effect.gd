class_name SlowEffect extends Effect

func act_start():
	print("Slowing enemy START")
	attached_enemy.slow(effect_duration)

func act_end():
	print("Slowing enemy END")
	attached_enemy.end_slow()

func can_act(enemy: Enemy):
	return not enemy.is_slowed
