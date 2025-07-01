class_name CreateTowerButtonStateCannotAfford
extends CreateTowerButtonState

func _enter_tree() -> void:
	print("CreateTowerButton is now cannot afford")

	_button.disabled = true

	BankManager.money_changed.connect(handle_money_changed)
