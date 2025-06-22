class_name TowerStateUpgrading
extends TowerState

func _enter_tree() -> void:
	print("%s has started upgrading" % _tower.tower_name)

	var upgrade_index := _state_data.get_upgrade_index()

	var next_level := _level_manager.start_upgrade(upgrade_index)
	if next_level:
		_barrel.pause()

		_progress_bars.upgrade_finished.connect(_on_upgrade_finished)

		_progress_bars.do_upgrade()

func _on_upgrade_finished() -> void:
	print("%s has finished upgrading" % _tower.tower_name)

	var next_level := _level_manager.finish_upgrade()

	_barrel.setup(next_level)
	_selection.enable_mouse()

	_tower.adjust_range(next_level.get_range(true))

	TowerEvents.emit_tower_upgrade_finished(_tower, next_level)

	transition_state(Tower.State.FIRING)

func is_upgrading() -> bool:
	return true
