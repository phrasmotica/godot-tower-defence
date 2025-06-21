class_name TowerManager extends Node2D

var all_towers: Array[Tower] = []
var selected_idx := 0
var selected_tower: Tower = null

signal selected_tower_changed(tower: Tower, was_unselected: bool)
signal tower_deselected

signal tower_sold(sell_value: int)

func _ready() -> void:
	KeyboardShortcuts.sell_tower.connect(_on_keyboard_shortcuts_sell_tower)

	LivesManager.lives_depleted.connect(_on_lives_manager_lives_depleted)

	TowerEvents.tower_selected.connect(_on_tower_selected)

func next_tower():
	if all_towers.size() <= 0:
		return

	if all_towers.size() == 1 and selected_tower:
		return

	print("Selecting next tower")

	if selected_tower:
		selected_idx = (selected_idx + 1) % all_towers.size()

	var new_tower = all_towers[selected_idx]
	select_tower(new_tower)

func previous_tower():
	if all_towers.size() <= 0:
		return

	if all_towers.size() == 1 and selected_tower:
		return

	print("Selecting previous tower")

	if selected_tower:
		selected_idx = (selected_idx - 1) % all_towers.size()

	var new_tower = all_towers[selected_idx]
	select_tower(new_tower)

func deselect_tower():
	if selected_tower == null:
		print("No tower is selected!")
		return

	unhighlight()
	selected_tower.deselect()
	selected_tower = null

	tower_deselected.emit()

func try_upgrade(index: int):
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

	var sell_value = selected_tower.sell()

	all_towers.remove_at(selected_idx)

	deselect_tower()

	tower_sold.emit(sell_value)

	BankManager.earn(sell_value)

func unhighlight():
	if selected_tower:
		selected_tower.reparent(self, true)

func select_tower(tower: Tower):
	if tower == selected_tower:
		print("This tower is already selected!")
		return

	var was_unselected := false

	if selected_tower:
		unhighlight()
		selected_tower.deselect()
	else:
		was_unselected = true

	selected_tower = tower
	selected_idx = all_towers.find(tower)

	if selected_tower:
		selected_tower.select()

	selected_tower_changed.emit(selected_tower, was_unselected)

func _on_game_ui_tower_placing(_tower: Tower):
	deselect_tower()

func _on_game_ui_tower_placed(tower: Tower):
	# ensure the tower is not part of the UI anymore
	tower.reparent(self, true)

	tower.on_warmed_up.connect(
		func(t, _first_level):
			all_towers.append(t)
	)

func _on_tower_selected(tower: Tower) -> void:
	unhighlight()

	select_tower(tower)

func _on_game_ui_next_tower():
	next_tower()

func _on_game_ui_previous_tower():
	previous_tower()

func _on_game_ui_upgrade_tower(index: int):
	try_upgrade(index)

func _on_game_ui_deselect_tower():
	deselect_tower()

func _on_game_ui_sell_tower():
	try_sell()

func _on_keyboard_shortcuts_sell_tower():
	try_sell()

func _on_lives_manager_lives_depleted():
	print("Game has ended; disabling towers")

	for t in all_towers:
		t.set_disabled()

func _on_game_ui_tower_target_mode_changed(index: int):
	set_target_mode(index)

func set_target_mode(index: int):
	if selected_tower:
		selected_tower.set_target_mode(index)
