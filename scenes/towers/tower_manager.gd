class_name TowerManager
extends Node2D

@export
var path_tint: Control

@export
var projectile_container: ProjectileContainer

var _tower_highlighter := TowerHighlighter.new()
var _tower_lister := TowerLister.new()
var _tower_selector: TowerSelector = null
var _tower_seller: TowerSeller = null
var _tower_upgrader: TowerUpgrader = null

func _ready() -> void:
	_tower_selector = TowerSelector.new(_tower_lister)
	_tower_upgrader = TowerUpgrader.new(_tower_selector)
	_tower_seller = TowerSeller.new(_tower_lister, _tower_selector)

	LivesManager.lives_depleted.connect(_on_lives_manager_lives_depleted)

	TowerEvents.tower_placing_started.connect(_on_tower_placing_started)
	TowerEvents.tower_placing_finished.connect(_on_tower_placing_finished)

	TowerEvents.tower_warmup_finished.connect(_on_tower_warmup_finished)

	TowerEvents.tower_selected.connect(_on_tower_selected)
	TowerEvents.tower_deselected.connect(deselect_tower)
	TowerEvents.next_tower.connect(next_tower)
	TowerEvents.previous_tower.connect(previous_tower)

	TowerEvents.upgrade_tower.connect(try_upgrade)
	TowerEvents.target_mode_changed.connect(_on_tower_target_mode_changed)
	TowerEvents.tower_sold.connect(try_sell)

func next_tower() -> void:
	var new_tower := _tower_selector.next_tower()
	select_tower(new_tower)

func previous_tower() -> void:
	var new_tower := _tower_selector.previous_tower()
	select_tower(new_tower)

func deselect_tower() -> void:
	var selected_tower := _tower_selector.get_current()

	if selected_tower:
		_tower_highlighter.unhighlight(selected_tower)
		selected_tower.deselect()
		_tower_selector.reset_current()
	else:
		print("No tower is selected!")

func try_upgrade(index: int) -> void:
	_tower_upgrader.try_upgrade(index)

func try_sell() -> void:
	_tower_seller.try_sell()

func select_tower(tower: Tower) -> void:
	var selected_tower := _tower_selector.get_current()

	if tower == selected_tower:
		print("%s is already selected!" % tower.name)
		return

	if selected_tower:
		_tower_highlighter.unhighlight(selected_tower)
		selected_tower.deselect()

	var old_tower := selected_tower

	_tower_selector.set_current(tower)

	if tower:
		_tower_highlighter.highlight(tower, path_tint.z_index)
		tower.select()

	TowerEvents.emit_selected_tower_changed(tower, old_tower)

func _on_tower_placing_started(_tower: Tower) -> void:
	deselect_tower()

func _on_tower_placing_finished(tower: Tower) -> void:
	# ensures the current state does not set up after re-entering tree
	tower.skip_state_transition_setup()
	tower.reparent(self, true)

func _on_tower_warmup_finished(tower: Tower, _first_level: TowerLevel) -> void:
	_tower_lister.append(tower)

	tower.projectile_created.connect(emit_projectile_created)
	tower.bolt_created.connect(emit_bolt_created)

func emit_projectile_created(projectile: Node2D) -> void:
	projectile_container.spawn_projectile(projectile)

func emit_bolt_created(bolt_line: BoltLine) -> void:
	projectile_container.spawn_bolt(bolt_line)

func _on_tower_selected(tower: Tower) -> void:
	select_tower(tower)

func _on_lives_manager_lives_depleted() -> void:
	print("Game has ended; disabling towers")

	for t in _tower_lister.list():
		t.set_disabled()

func _on_tower_target_mode_changed(index: int) -> void:
	var selected_tower := _tower_selector.get_current()

	if selected_tower:
		selected_tower.set_target_mode(index)
