class_name PoisonEffect extends Effect

func act_start():
	print("Poisoning enemies START")

	for enemy in attached_enemies:
		enemy.poison(effect_duration)

func act_end():
	print("Poisoning enemies END")

	for enemy in attached_enemies:
		if is_instance_valid(enemy):
			enemy.end_poison()

func can_act(enemy: Enemy):
	return not enemy.is_poisoned
