class_name UpgradeTowerButtonStateEnabled
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("UpgradeTowerButton is now enabled")

	_button.disabled = false
	_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	_button.pressed.connect(_on_pressed)

	BankManager.money_changed.connect(_on_money_changed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(_button.action_name):
		print("Upgrading tower via shortcut")
		transition_state(UpgradeTowerButton.State.UPGRADING)

func _on_money_changed(_old_money: int, new_money: int) -> void:
	update_affordability(new_money)

func _on_pressed() -> void:
	print("Upgrading tower via button")
	transition_state(UpgradeTowerButton.State.UPGRADING)
