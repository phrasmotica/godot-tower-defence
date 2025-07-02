class_name UpgradeTowerButtonStateCannotAfford
extends UpgradeTowerButtonState

func _enter_tree() -> void:
	print("%s is now cannot afford" % get_button_name())

	_button.disabled = true

	TowerEvents.tower_upgrade_started.connect(_on_tower_upgrade_started)

func _on_tower_upgrade_started(_index: int, _tower: Tower, _next_level: TowerLevel) -> void:
	# we can assume this button is not for the index of upgrade that started,
	# so disable this button for now and we'll resolve its next state once the
	# upgrade finishes
	transition_state(UpgradeTowerButton.State.DISABLED)
