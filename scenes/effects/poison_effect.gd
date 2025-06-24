class_name PoisonEffect extends Effect

@export_range(1.0, 3.0)
var damage_per_second := 1.0

func act_start():
	print("Poisoning enemies START")

	for enemy in attached_enemies:
		enemy.poison(self)

	set_process(true)

func act_process(delta):
	var damage = delta * damage_per_second

	for enemy in attached_enemies:
		if is_instance_valid(enemy):
			# print("Damaging " + str(damage))
			enemy.handle_damage(damage)

func act_end():
	print("Poisoning enemies END")

	set_process(false)

func can_act(enemy: Enemy):
	return enemy.can_be_poisoned()
