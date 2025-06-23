class_name ParalyseEffect extends Effect

func act_start():
	print("Paralysing enemies START")

	for enemy in attached_enemies:
		enemy.paralyse(effect_duration)

func act_end():
	print("Paralysing enemies END")

func can_act(enemy: Enemy) -> bool:
	return enemy.can_be_paralysed()
