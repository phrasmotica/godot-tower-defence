class_name ParalyseEffect extends Effect

func act_start():
	print("Paralysing enemies START")

	for enemy in attached_enemies:
		enemy.paralyse(effect_duration)

func act_end():
	print("Paralysing enemies END")

	for enemy in attached_enemies:
		if is_instance_valid(enemy):
			enemy.end_paralyse()

func can_act(enemy: Enemy):
	return not enemy.is_paralysed
