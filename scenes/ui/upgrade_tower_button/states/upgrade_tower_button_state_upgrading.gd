class_name UpgradeTowerButtonStateUpgrading
extends UpgradeTowerButtonState

var _money_after_upgrade := 0

func _enter_tree() -> void:
	print("%s is now upgrading" % get_button_name())

	_button.tooltip.hide()

	BankManager.money_changed.connect(_on_money_changed)

	TowerEvents.tower_upgrade_finished.connect(_on_upgrade_finished)
	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)

func _on_money_changed(_old_money: int, new_money: int) -> void:
	_money_after_upgrade = new_money
	update_affordability(_money_after_upgrade)

func _on_upgrade_finished(_tower: Tower, _next_level: TowerLevel) -> void:
	# TODO: why isn't this being hit??
	update_affordability(_money_after_upgrade)

func _on_selected_tower_changed(_new_tower: Tower, _old_tower: Tower) -> void:
	update_affordability(_money_after_upgrade)

func _on_tower_deselected() -> void:
	update_affordability(_money_after_upgrade)
