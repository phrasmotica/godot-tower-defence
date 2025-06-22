class_name TowerStateFiring
extends TowerState

var _is_selected := false

func _enter_tree() -> void:
	print("Tower is now firing")

	_selection.mouse_filter = Control.MOUSE_FILTER_STOP

	_selection.mouse_entered.connect(_on_selection_mouse_entered)
	_selection.mouse_exited.connect(_on_selection_mouse_exited)
	_selection.gui_input.connect(_on_selection_gui_input)

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

func _on_selection_mouse_entered() -> void:
	_appearance.show_visualiser()

func _on_selection_mouse_exited() -> void:
	if not _is_selected:
		_appearance.hide_visualiser()

func _on_selection_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and not _is_selected:
		TowerEvents.emit_tower_selected(_tower)

func can_be_selected() -> bool:
	return true

func select() -> void:
	_appearance.show_visualiser()
	_appearance.show_range()
	_is_selected = true

func deselect() -> void:
	_appearance.hide_visualiser()
	_appearance.hide_range()
	_is_selected = false
