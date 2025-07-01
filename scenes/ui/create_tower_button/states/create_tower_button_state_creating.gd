class_name CreateTowerButtonStateCreating
extends CreateTowerButtonState

var _original_icon: Texture2D = null

func _enter_tree() -> void:
	print("CreateTowerButton is now creating")

	TowerEvents.emit_tower_created(_button.tower)

	_button.tooltip.hide()

	_original_icon = _button.icon
	_button.icon = null

	_button.mouse_entered.connect(_on_mouse_entered)

	TowerEvents.tower_placing_finished.connect(_on_tower_placing_finished)

	BankManager.money_changed.connect(handle_money_changed)

func _on_mouse_entered() -> void:
	TowerEvents.emit_tower_placing_cancelled()

	transition_state(CreateTowerButton.State.ENABLED)

func _on_tower_placing_finished(_tower: Tower) -> void:
	_button.icon = _original_icon

	# don't go back to ENABLED - we might not be able to afford this tower.
	# Let the BankManager.money_changed handler do the transition
