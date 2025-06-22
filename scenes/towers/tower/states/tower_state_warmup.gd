class_name TowerStateWarmup
extends TowerState

func _enter_tree() -> void:
	print("%s is now warming up" % _tower.tower_name)

	_appearance.hide_visualiser()

	_weaponry.start_warmup()

	_selection.mouse_filter = Control.MOUSE_FILTER_STOP

	_selection.mouse_entered.connect(_on_selection_mouse_entered)
	_selection.mouse_exited.connect(_on_selection_mouse_exited)

	_appearance.do_warmup(_on_warmup_finished)

func _on_selection_mouse_entered() -> void:
	_appearance.show_visualiser()

func _on_selection_mouse_exited() -> void:
	_appearance.hide_visualiser()

func _on_warmup_finished() -> void:
	print("%s has finished warming up" % _tower.tower_name)

	_selection.enable_mouse()

	var base_level := _weaponry.install_base()

	TowerEvents.emit_tower_warmup_finished(_tower, base_level)

	transition_state(Tower.State.FIRING)
