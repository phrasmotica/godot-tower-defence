class_name CreateTowerButtonStateCreating
extends CreateTowerButtonState

var _original_icon: Texture2D = null

func _enter_tree() -> void:
	Logger.info("%s is now creating" % get_button_name())

	_button.tooltip.hide()

	_original_icon = _button.icon
	_button.icon = null

	_button.mouse_entered.connect(_on_mouse_entered)

	TowerEvents.tower_placing_finished.connect(_on_tower_placing_finished)
	TowerEvents.tower_placing_cancelled.connect(_on_tower_placing_cancelled)

	BankManager.money_changed.connect(_on_money_changed)

	TowerEvents.emit_tower_created(_button.tower)

	# do this last so that we don't induce the callback by ourselves!
	TowerEvents.tower_created.connect(_on_tower_created)

func _on_mouse_entered() -> void:
	TowerEvents.emit_tower_placing_cancelled()

	transition_state(CreateTowerButton.State.ENABLED)

func _on_money_changed(old_money: int, new_money: int) -> void:
	resolve_state(old_money, new_money)

func _on_tower_created(tower_scene: PackedScene) -> void:
	if tower_scene != _button.tower:
		# we're now placing a different tower, so revert
		_button.icon = _original_icon

		transition_state(CreateTowerButton.State.ENABLED)

func _on_tower_placing_finished(_tower: Tower) -> void:
	_button.icon = _original_icon

	# don't go back to ENABLED - we might not be able to afford this tower.
	# Let the BankManager.money_changed handler do the transition

func _on_tower_placing_cancelled() -> void:
	_button.icon = _original_icon

	transition_state(CreateTowerButton.State.ENABLED)
