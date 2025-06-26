class_name TowerManager
extends Node2D

@export
var path_tint: Control

@export
var projectile_container: ProjectileContainer

var all_towers: Array[Tower] = []
var selected_idx := 0
var selected_tower: Tower = null

# TODO: turn this script into an auto-load. It only reacts to signals from other auto-loads...
func _ready() -> void:
	LivesManager.lives_depleted.connect(_on_lives_manager_lives_depleted)

	TowerEvents.tower_placing_started.connect(_on_tower_placing_started)

	TowerEvents.tower_warmup_finished.connect(_on_tower_warmup_finished)

	TowerEvents.tower_selected.connect(_on_tower_selected)
	TowerEvents.tower_deselected.connect(deselect_tower)
	TowerEvents.next_tower.connect(next_tower)
	TowerEvents.previous_tower.connect(previous_tower)

	TowerEvents.upgrade_tower.connect(try_upgrade)
	TowerEvents.target_mode_changed.connect(_on_tower_target_mode_changed)
	TowerEvents.tower_sold.connect(try_sell)

func next_tower() -> void:
	if all_towers.size() <= 0:
		return

	if all_towers.size() == 1 and selected_tower:
		return

	print("Selecting next tower")

	if selected_tower:
		selected_idx = (selected_idx + 1) % all_towers.size()

	var new_tower = all_towers[selected_idx]
	select_tower(new_tower)

func previous_tower() -> void:
	if all_towers.size() <= 0:
		return

	if all_towers.size() == 1 and selected_tower:
		return

	print("Selecting previous tower")

	if selected_tower:
		selected_idx = (selected_idx - 1) % all_towers.size()

	var new_tower = all_towers[selected_idx]
	select_tower(new_tower)

func deselect_tower() -> void:
	if selected_tower:
		unhighlight(selected_tower)
		selected_tower.deselect()
		selected_tower = null
	else:
		print("No tower is selected!")

func try_upgrade(index: int) -> void:
	if not selected_tower:
		print("Tower upgrade failed: no tower selected")
		return

	var next_level = selected_tower.get_upgrade(index)
	if not next_level:
		print("Tower upgrade failed: no more upgrades")
		return

	if selected_tower.is_upgrading():
		print("Tower upgrade failed: already upgrading")
		return

	if not BankManager.can_afford(next_level.price):
		print("Tower upgrade failed: cannot afford")
		return

	print("Upgrading tower")

	selected_tower.upgrade(index)

	BankManager.deduct(next_level.price)

	TowerEvents.emit_tower_upgrade_started(selected_tower, next_level)

func try_sell():
	if not selected_tower:
		print("Tower sell failed: no tower selected")
		return

	print("Selling tower")

	all_towers.remove_at(selected_idx)

	selected_tower.deselect()
	selected_tower.sell()
	selected_tower = null

func highlight(tower: Tower) -> void:
	tower.z_index = path_tint.z_index + 1

func unhighlight(tower: Tower) -> void:
	tower.z_index = 0

func select_tower(tower: Tower) -> void:
	if tower == selected_tower:
		print("%s is already selected!" % tower.name)
		return

	if selected_tower:
		unhighlight(selected_tower)
		selected_tower.deselect()

	var old_tower := selected_tower

	selected_tower = tower
	selected_idx = all_towers.find(tower)

	if selected_tower:
		highlight(selected_tower)
		selected_tower.select()

	TowerEvents.emit_selected_tower_changed(selected_tower, old_tower)

func _on_tower_placing_started(tower: Tower) -> void:
	deselect_tower()

	add_child(tower)

func _on_tower_warmup_finished(tower: Tower, _first_level: TowerLevel) -> void:
	all_towers.append(tower)

	tower.projectile_created.connect(emit_projectile_created)
	tower.bolt_created.connect(emit_bolt_created)

func emit_projectile_created(projectile: Projectile) -> void:
	projectile_container.spawn_projectile(projectile)

func emit_bolt_created(bolt_line: BoltLine) -> void:
	projectile_container.spawn_bolt(bolt_line)

func _on_tower_selected(tower: Tower) -> void:
	select_tower(tower)

func _on_lives_manager_lives_depleted() -> void:
	print("Game has ended; disabling towers")

	for t in all_towers:
		t.set_disabled()

func _on_tower_target_mode_changed(index: int) -> void:
	set_target_mode(index)

func set_target_mode(index: int):
	if selected_tower:
		selected_tower.set_target_mode(index)
