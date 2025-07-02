class_name CreateTowerButtonStateCannotAfford
extends CreateTowerButtonState

func _enter_tree() -> void:
	Logger.info("%s is now cannot afford" % get_button_name())

	_button.disabled = true

	BankManager.money_changed.connect(_on_money_changed)

func _on_money_changed(old_money: int, new_money: int) -> void:
	resolve_state(old_money, new_money)
