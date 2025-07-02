class_name UpgradeTowerButtonStateDisabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now disabled" % get_button_name())

	_upgrade_level = _state_data.get_upgrade_level()
	_appearance.set_upgrade_level(_upgrade_level)

	_button.disabled = true

	_button.mouse_entered.connect(_on_mouse_entered)
	_button.mouse_exited.connect(_on_mouse_exited)

	_appearance.hide_tooltip()

	BankManager.money_changed.connect(_on_money_changed)

	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)

	TowerEvents.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

func _on_money_changed(_old_money: int, new_money: int) -> void:
	resolve_state(new_money)

func _on_selected_tower_changed(new_tower: Tower, _old_tower: Tower) -> void:
	set_upgrade_level(new_tower)

func _on_tower_deselected() -> void:
	set_upgrade_level(null)

func _on_tower_upgrade_finished(_index: int, tower: Tower, _next_level: TowerLevel) -> void:
	set_upgrade_level(tower)

func _on_mouse_entered() -> void:
	if _upgrade_level:
		_appearance.show_tooltip()

func _on_mouse_exited() -> void:
	_appearance.hide_tooltip()
