class_name UpgradeTowerButtonStateUnavailable
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now unavailable" % get_button_name())

	_upgrade_level = _state_data.get_upgrade_level()

	_button.disabled = true
	_button.mouse_default_cursor_shape = Control.CURSOR_ARROW

	_appearance.set_upgrade_level(null)

	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)

	TowerEvents.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

func _on_selected_tower_changed(new_tower: Tower, _old_tower: Tower) -> void:
	set_upgrade_level(new_tower)

func _on_tower_deselected() -> void:
	set_upgrade_level(null)

func _on_tower_upgrade_finished(_index: int, tower: Tower, _next_level: TowerLevel) -> void:
	set_upgrade_level(tower)
