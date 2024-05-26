class_name PoisonEffect extends Effect

@export_range(1.0, 3.0)
var damage_per_second := 1.0

func act_start():
	print("Poisoning enemies START")

	for enemy in attached_enemies:
		enemy.poison(effect_duration)

	set_process(true)

func act_process(delta):
	var damage = delta * damage_per_second

	for enemy in attached_enemies:
		print("Damaging " + str(damage))
		enemy.handle_damage(damage)

func act_end():
	print("Poisoning enemies END")

	for enemy in attached_enemies:
		if is_instance_valid(enemy):
			enemy.end_poison()

	set_process(false)

func can_act(enemy: Enemy):
	return not enemy.is_poisoned
