class_name TowerStateFiring
extends TowerState

func _enter_tree() -> void:
	print("Tower is now firing")

	_interaction.mouse_entered.connect(_on_mouse_entered)
	_interaction.mouse_exited.connect(_on_mouse_exited)
	_interaction.clicked.connect(_on_clicked)

	_interaction.enable_mouse()

	_weaponry.bolt_created.connect(_on_bolt_created)
	_weaponry.effect_created.connect(_on_effect_created)
	_weaponry.projectile_created.connect(_on_projectile_created)

	_weaponry.for_firing(_tower, _path_manager)

func _process(delta: float) -> void:
	_weaponry.scan(delta)

func _on_projectile_created(projectile: Projectile) -> void:
	print("Adding projectile as child")

	_appearance.animate_shoot()

	# BUG: projectiles get freed when the tower is sold. Probably happens
	# with bolt lines too...
	_tower.add_child(projectile)

func _on_effect_created(effect: Effect, enemies: Array[Enemy]) -> void:
	var valid_enemies := enemies.filter(
		func(e: Enemy) -> bool:
			return effect.can_act(e)
	)

	if valid_enemies.size() > 0:
		print("Passing effect to enemies")

		effect.attached_enemies = enemies
		effect.act_start()

	_appearance.animate_pulse()

	effect.start_timer()

func _on_bolt_created(bolt_line: BoltLine) -> void:
	_appearance.animate_shoot()

	_tower.add_child(bolt_line)

func _on_mouse_entered() -> void:
	_appearance.show_visualiser()

func _on_mouse_exited() -> void:
	if not _interaction.is_selected():
		_appearance.hide_visualiser()

func _on_clicked() -> void:
	if not _interaction.is_selected():
		TowerEvents.emit_tower_selected(_tower)

func can_be_selected() -> bool:
	return true
