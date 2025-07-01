class_name CreateTowerButtonStateDisabled
extends CreateTowerButtonState

func _enter_tree() -> void:
	print("CreateTowerButton is now disabled")

	_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
