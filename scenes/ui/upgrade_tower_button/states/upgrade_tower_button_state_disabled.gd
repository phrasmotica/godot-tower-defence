class_name UpgradeTowerButtonStateDisabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now disabled" % get_button_name())

	_button.disabled = true
	_button.mouse_default_cursor_shape = Control.CURSOR_ARROW

	_appearance.set_upgrade_level(null)
