@tool
class_name TowerUI extends Control

@export
var tower_name_label: Label

@export
var upgrade_button_0: UpgradeTowerButton

@export
var upgrade_button_1: UpgradeTowerButton

@export
var sell_button: SellButton

signal target_mode_changed(index: int)
signal upgrade_tower(index: int)
signal sell_tower

func disable_upgrades():
	upgrade_button_0.disabled = true
	upgrade_button_0.disable_button(false)

	upgrade_button_1.disabled = true
	upgrade_button_1.disable_button(false)

func update_affordability(new_money: int):
	if upgrade_button_0:
		upgrade_button_0.update_affordability(new_money)

	if upgrade_button_1:
		upgrade_button_1.update_affordability(new_money)

func set_tower(tower: Tower):
	tower_name_label.text = tower.tower_name if tower else ""

	upgrade_button_0.set_upgrade_level(tower)
	upgrade_button_1.set_upgrade_level(tower)

	sell_button.set_tower(tower)

func _on_upgrade_button_upgrade_tower(index: int):
	upgrade_tower.emit(index)

func _on_target_mode_options_item_selected(index: int):
	target_mode_changed.emit(index)

func _on_sell_button_sell_tower():
	sell_tower.emit()
