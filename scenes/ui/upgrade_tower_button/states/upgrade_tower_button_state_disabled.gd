class_name UpgradeTowerButtonStateDisabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("UpgradeTowerButton is now disabled")

	_button.disabled = true
	_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
