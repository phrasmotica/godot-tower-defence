class_name UpgradeTowerButtonStateEnabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now enabled" % get_button_name())

	_button.disabled = false
	_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	_button.mouse_entered.connect(_on_mouse_entered)
	_button.mouse_exited.connect(_on_mouse_exited)

	_button.pressed.connect(_on_pressed)

	TowerEvents.tower_upgrade_started.connect(_on_tower_upgrade_started)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(_button.action_name):
		print("%s upgrading via shortcut" % get_button_name())
		TowerEvents.emit_upgrade_tower(_button.upgrade_index)

func _on_tower_upgrade_started(_index: int, _tower: Tower, _next_level: TowerLevel) -> void:
	# we can assume this upgrade is for the selected tower
	transition_state(UpgradeTowerButton.State.DISABLED)

func _on_mouse_entered() -> void:
	if _button.upgrade_level:
		_appearance.show_tooltip()

func _on_mouse_exited() -> void:
	_appearance.hide_tooltip()

func _on_pressed() -> void:
	print("%s upgrading via button" % get_button_name())
	TowerEvents.emit_upgrade_tower(_button.upgrade_index)
