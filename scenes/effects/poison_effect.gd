class_name PoisonEffect extends Effect

@export_range(1.0, 3.0)
var damage_per_second := 1.0

func _enter_tree() -> void:
	enemy.poison(self)

func _process(delta: float) -> void:
	var damage = delta * damage_per_second

	if is_instance_valid(enemy) and enemy.can_take_damage():
		enemy.handle_damage(damage)

func can_act() -> bool:
	return enemy.can_be_poisoned()
