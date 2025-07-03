extends Node

signal tower_created(tower_scene: PackedScene)

signal tower_placing_started(tower: Tower)
signal tower_placing_cancelled
signal tower_placing_finished(tower: Tower)

signal tower_warmup_finished(tower: Tower, first_level: TowerLevel)

signal tower_selected(tower: Tower)
signal next_tower
signal previous_tower
signal selected_tower_changed(new_tower: Tower, old_tower: Tower)
signal tower_deselected()

signal upgrade_tower(index: int)
signal tower_upgrade_started(index: int, tower: Tower, next_level: TowerLevel)
signal tower_upgrade_finished(index: int, tower: Tower, next_level: TowerLevel)

signal target_mode_changed(index: int)
signal tower_sold

func emit_tower_created(tower_scene: PackedScene) -> void:
	Logger.debug("Tower created")

	tower_created.emit(tower_scene)

func emit_tower_placing_started(tower: Tower) -> void:
	Logger.debug("Started placing %s" % tower.name)

	tower_placing_started.emit(tower)

func emit_tower_placing_cancelled() -> void:
	Logger.debug("Tower placing cancelled")

	tower_placing_cancelled.emit()

func emit_tower_warmup_finished(tower: Tower, first_level: TowerLevel) -> void:
	Logger.debug("Finished warmup %s" % tower.name)

	tower_warmup_finished.emit(tower, first_level)

func emit_tower_placing_finished(tower: Tower) -> void:
	Logger.debug("Finished placing %s" % tower.name)

	tower_placing_finished.emit(tower)

func emit_tower_selected(tower: Tower) -> void:
	Logger.debug("Selected %s" % tower.name)

	tower_selected.emit(tower)

func emit_next_tower() -> void:
	Logger.debug("Next tower")

	next_tower.emit()

func emit_previous_tower() -> void:
	Logger.debug("Previous tower")

	previous_tower.emit()

func emit_selected_tower_changed(new_tower: Tower, old_tower: Tower) -> void:
	var new_name := new_tower.name if new_tower else &"<null>"
	var old_name := old_tower.name if old_tower else &"<null>"

	Logger.debug("Selected tower changed %s -> %s" % [old_name, new_name])

	selected_tower_changed.emit(new_tower, old_tower)

func emit_tower_deselected() -> void:
	Logger.debug("Tower deselected")

	tower_deselected.emit()

func emit_upgrade_tower(index: int) -> void:
	Logger.debug("Upgrade tower, index=%d" % index)

	upgrade_tower.emit(index)

func emit_tower_upgrade_started(index: int, tower: Tower, next_level: TowerLevel) -> void:
	Logger.debug("%s upgrade index=%d started" % [tower.name, index])

	tower_upgrade_started.emit(index, tower, next_level)

func emit_tower_upgrade_finished(index: int, tower: Tower, next_level: TowerLevel) -> void:
	Logger.debug("%s upgrade index=%d finished" % [tower.name, index])

	tower_upgrade_finished.emit(index, tower, next_level)

func emit_target_mode_changed(index: int) -> void:
	Logger.debug("Target mode changed")

	target_mode_changed.emit(index)

func emit_tower_sold() -> void:
	Logger.debug("Tower sold")

	tower_sold.emit()
