class_name UpgradeTowerButtonStateCannotAfford
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now cannot afford" % get_button_name())

	_button.disabled = true

	BankManager.money_changed.connect(_on_money_changed)

func _on_money_changed(_old_money: int, new_money: int) -> void:
	resolve_state(new_money)
