extends Node

signal tower_placing_started(tower: Tower)
signal tower_placing_finished(tower: Tower)

signal deselect_tower
signal tower_selected(tower: Tower)
signal next_tower
signal previous_tower

signal upgrade_tower(index: int)
signal tower_upgrade_started(tower: Tower, next_level: TowerLevel)
signal tower_upgrade_finished(tower: Tower, next_level: TowerLevel)

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

func emit_deselect_tower() -> void:
	print("Deselect tower")

	deselect_tower.emit()

func emit_next_tower() -> void:
	print("Next tower")

	next_tower.emit()

func emit_previous_tower() -> void:
	print("Previous tower")

	previous_tower.emit()

func emit_upgrade_tower(index: int) -> void:
	print("Upgrade tower, index=%d" % index)

	upgrade_tower.emit(index)

func emit_tower_upgrade_started(tower: Tower, next_level: TowerLevel) -> void:
	print(tower.name + " upgrade started")

	tower_upgrade_started.emit(tower, next_level)

func emit_tower_upgrade_finished(tower: Tower, next_level: TowerLevel) -> void:
	print(tower.name + " upgrade finished")

	tower_upgrade_finished.emit(tower, next_level)

func emit_sell_tower() -> void:
	print("Sell tower")

	sell_tower.emit()
