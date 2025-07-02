class_name UpgradeTowerButtonStateUpgrading
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now upgrading" % get_button_name())

	_button.disabled = true

	_appearance.hide_tooltip()
