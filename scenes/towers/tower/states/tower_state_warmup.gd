class_name TowerStateWarmup
extends TowerState

func _enter_tree() -> void:
	print("%s is now warming up" % _tower.tower_name)

	_tower.hide_visualiser()

	_level_manager.start_warmup()

	_progress_bars.warmup_finished.connect(_on_warmup_finished)

	_progress_bars.do_warmup()

func _on_warmup_finished() -> void:
	print("%s has finished warming up" % _tower.tower_name)

	var first_level := _level_manager.finish_warmup()

	_barrel.setup(first_level)
	_selection.enable_mouse()

	TowerEvents.emit_tower_warmup_finished(_tower, first_level)

	transition_state(Tower.State.FIRING)
