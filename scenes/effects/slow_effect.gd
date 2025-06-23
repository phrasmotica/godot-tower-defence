class_name SlowEffect extends Effect

func act_start():
	print("Slowing enemies START")

	for enemy in attached_enemies:
		enemy.slow(effect_duration)

func act_end():
	print("Slowing enemies END")

func can_act(enemy: Enemy) -> bool:
	return enemy.can_be_slowed()
