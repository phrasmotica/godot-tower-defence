class_name UpgradeTowerButtonStateDisabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now disabled" % get_button_name())

	_button.disabled = true

	_button.mouse_entered.connect(_on_mouse_entered)
	_button.mouse_exited.connect(_on_mouse_exited)

	_appearance.hide_tooltip()

	BankManager.money_changed.connect(_on_money_changed)

func _on_money_changed(_old_money: int, new_money: int) -> void:
	_button._money_from_bank = new_money
	resolve_state(new_money)

func _on_mouse_entered() -> void:
	if _button.upgrade_level:
		_appearance.show_tooltip()

func _on_mouse_exited() -> void:
	_appearance.hide_tooltip()
