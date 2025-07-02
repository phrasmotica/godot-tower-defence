class_name UpgradeTowerButtonStateDisabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now disabled" % get_button_name())

	_button.disabled = true

	_appearance.hide_tooltip()
