class_name UpgradeTowerButtonStateEnabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now enabled" % get_button_name())

	_button.disabled = false
	_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	_button.pressed.connect(_on_pressed)

	BankManager.money_changed.connect(_on_money_changed)

	TowerEvents.tower_upgrade_started.connect(_on_tower_upgrade_started)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(_button.action_name):
		print("%s upgrading via shortcut" % get_button_name())
		TowerEvents.emit_upgrade_tower(_button.upgrade_index)

func _on_money_changed(_old_money: int, new_money: int) -> void:
	update_affordability(new_money)

func _on_pressed() -> void:
	print("%s upgrading via button" % get_button_name())
	TowerEvents.emit_upgrade_tower(_button.upgrade_index)

func _on_tower_upgrade_started(_index: int, _tower: Tower, _next_level: TowerLevel) -> void:
	transition_state(UpgradeTowerButton.State.UPGRADING)
