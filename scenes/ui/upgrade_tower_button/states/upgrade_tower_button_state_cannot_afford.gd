class_name UpgradeTowerButtonStateCannotAfford
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now cannot afford" % get_button_name())

	_button.disabled = true
