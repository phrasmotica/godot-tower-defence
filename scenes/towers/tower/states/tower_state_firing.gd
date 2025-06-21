class_name TowerStateFiring
extends TowerState

var enemy_sorter := EnemySorter.new()

func _enter_tree() -> void:
	print("Tower is now firing")

	_selection.mouse_filter = Control.MOUSE_FILTER_STOP

	_selection.mouse_entered.connect(_on_selection_mouse_entered)
	_selection.mouse_exited.connect(_on_selection_mouse_exited)
	_selection.gui_input.connect(_on_selection_gui_input)

	_level_manager.created_projectile.connect(_on_created_projectile)
	_level_manager.created_effect.connect(_on_created_effect)

	if _firing_line:
		_firing_line.created_line.connect(_on_created_line)

	_barrel.shoot.connect(_on_barrel_shoot)
	_barrel.pulse.connect(_on_barrel_pulse)
	_barrel.bolt.connect(_on_barrel_bolt)

func _process(delta: float) -> void:
	scan(delta)

func scan(delta: float) -> void:
	var near_enemy = get_near_enemy(false)
	if near_enemy:
		_level_manager.point_towards_enemy(near_enemy, delta)

func get_near_enemy(for_effect: bool) -> Enemy:
	var enemies := get_near_enemies(for_effect)
	return enemies[0] if enemies.size() > 0 else null

func get_near_enemies(for_effect: bool) -> Array[Enemy]:
	var enemies = _path_manager.enemies
	if enemies.size() <= 0:
		return []

	var valid_enemies = enemies.filter(func(e): return e != null and not e.is_queued_for_deletion())
	if valid_enemies.size() <= 0:
		return []

	var shooting_range = get_range_px(for_effect)

	var in_range_enemies = valid_enemies.filter(
		func(e):
			return e.get_distance_to(_tower.global_position) <= shooting_range
	)

	if in_range_enemies.size() <= 0:
		return []

	match _tower.target_mode:
		Tower.TargetMode.STRONG:
			enemy_sorter.strong(in_range_enemies)
		Tower.TargetMode.FAR:
			enemy_sorter.far(in_range_enemies, _tower.global_position)
		_:
			# nearest enemies first by default
			enemy_sorter.near(in_range_enemies, _tower.global_position)

	return in_range_enemies

func get_range_px(for_effect: bool):
	var current_level = _level_manager.get_current_level()
	var actual_range = current_level.get_range(for_effect)

	# 1 range => 100px
	return actual_range * 100

func should_shoot(enemies: Array[Enemy]):
	return enemies.size() > 0

func should_create_effect(enemies: Array[Enemy]):
	return _level_manager.should_create_effect(enemies)

func should_bolt(enemies: Array[Enemy]):
	return _level_manager.should_bolt(enemies)

func _on_barrel_shoot() -> void:
	var in_range_enemies = get_near_enemies(false)
	if not should_shoot(in_range_enemies):
		return

	var level = _level_manager.get_current_level()

	level.try_create_projectile()

func _on_barrel_pulse() -> void:
	var in_range_enemies = get_near_enemies(true)
	if not should_create_effect(in_range_enemies):
		return

	var level = _level_manager.get_current_level()

	level.try_create_effect()

func _on_barrel_bolt() -> void:
	var in_range_enemies = get_near_enemies(false)

	if not should_bolt(in_range_enemies):
		return

	var level = _level_manager.get_current_level()

	level.try_shoot_bolt()

func _on_created_projectile(projectile: Projectile) -> void:
	print("Adding projectile as child")

	animate_shoot()

	# BUG: projectiles get freed when the tower is sold. Probably happens
	# with bolt lines too...
	_tower.add_child(projectile)

func _on_created_effect(effect: Effect) -> void:
	var enemies := get_near_enemies(true)
	var valid_enemies := enemies.filter(func(e): return effect.can_act(e))

	if valid_enemies.size() > 0:
		print("Passing effect to enemies")

		effect.attached_enemies = enemies
		effect.act_start()

	animate_pulse()

	effect.start_timer()

func _on_created_line(bolt_line: BoltLine) -> void:
	print("Adding bolt line as child")

	bolt_line.rotation = _level_manager.rotation
	bolt_line.fire()

	animate_shoot()

	_tower.add_child(bolt_line)

func animate_shoot() -> void:
	if _animation_player.current_animation.length() <= 0:
		_animation_player.play("shoot")

func animate_pulse() -> void:
	if _animation_player.current_animation.length() <= 0:
		_animation_player.play("pulse")

func _on_selection_mouse_entered() -> void:
	_visualiser.show()

func _on_selection_mouse_exited() -> void:
	if not _tower.is_selected:
		_visualiser.hide()

func _on_selection_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and not _tower.is_selected:
		TowerEvents.emit_tower_selected(_tower)
