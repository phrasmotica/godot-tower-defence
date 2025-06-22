class_name TowerStateFiring
extends TowerState

var _enemy_finder: EnemyFinder = null
var _is_selected := false

func _enter_tree() -> void:
	print("Tower is now firing")

	_enemy_finder = EnemyFinder.new(_tower, _level_manager, _path_manager)

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
	var near_enemy = _enemy_finder.get_near_enemy(false)
	if near_enemy:
		_level_manager.point_towards_enemy(near_enemy, delta)

func _on_barrel_shoot() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(false)
	if in_range_enemies.size() <= 0:
		return

	var level = _level_manager.get_current_level()

	level.try_create_projectile()

func _on_barrel_pulse() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(true)
	if not _level_manager.should_create_effect(in_range_enemies):
		return

	var level = _level_manager.get_current_level()

	level.try_create_effect()

func _on_barrel_bolt() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(false)

	if not _level_manager.should_bolt(in_range_enemies):
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
	var enemies := _enemy_finder.get_near_enemies(true)

	var valid_enemies := enemies.filter(
		func(e: Enemy) -> bool:
			return effect.can_act(e)
	)

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
