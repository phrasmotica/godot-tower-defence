extends Node

signal tower_placing_started(tower: Tower)
signal tower_placing_finished(tower: Tower)

signal tower_selected(tower: Tower)
signal next_tower
signal previous_tower
signal selected_tower_changed(new_tower: Tower, old_tower: Tower)
signal tower_deselected()

signal upgrade_tower(index: int)
signal tower_upgrade_started(tower: Tower, next_level: TowerLevel)
signal tower_upgrade_finished(tower: Tower, next_level: TowerLevel)

signal target_mode_changed(index: int)
signal sell_tower

func emit_tower_placing_started(tower: Tower) -> void:
	print("Started placing " + tower.name)

	tower_placing_started.emit(tower)

func emit_tower_placing_finished(tower: Tower) -> void:
	print("Finished placing " + tower.name)

	tower_placing_finished.emit(tower)

func emit_tower_selected(tower: Tower) -> void:
	print("Selected " + tower.name)

	tower_selected.emit(tower)

func emit_next_tower() -> void:
	print("Next tower")

	next_tower.emit()

func emit_previous_tower() -> void:
	print("Previous tower")

	previous_tower.emit()

func emit_selected_tower_changed(new_tower: Tower, old_tower: Tower) -> void:
	var new_name := new_tower.name if new_tower else &"<null>"
	var old_name := old_tower.name if old_tower else &"<null>"

	print("Selected tower changed %s -> %s" % [old_name, new_name])

	selected_tower_changed.emit(new_tower, old_tower)

func emit_tower_deselected() -> void:
	print("Tower deselected")

	tower_deselected.emit()

func emit_upgrade_tower(index: int) -> void:
	print("Upgrade tower, index=%d" % index)

	upgrade_tower.emit(index)

func emit_tower_upgrade_started(tower: Tower, next_level: TowerLevel) -> void:
	print(tower.name + " upgrade started")

	tower_upgrade_started.emit(tower, next_level)

func emit_tower_upgrade_finished(tower: Tower, next_level: TowerLevel) -> void:
	print(tower.name + " upgrade finished")

	tower_upgrade_finished.emit(tower, next_level)

func emit_target_mode_changed(index: int) -> void:
	print("Target mode changed")

	target_mode_changed.emit(index)

func emit_sell_tower() -> void:
	print("Sell tower")

	sell_tower.emit()
