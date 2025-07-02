class_name UpgradeTowerButtonStateDisabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now disabled" % get_button_name())

	_button.disabled = true

	_button.mouse_entered.connect(_on_mouse_entered)
	_button.mouse_exited.connect(_on_mouse_exited)

	_appearance.hide_tooltip()

func _on_mouse_entered() -> void:
	if _button.upgrade_level:
		_appearance.show_tooltip()

func _on_mouse_exited() -> void:
	_appearance.hide_tooltip()
