@tool
class_name TowerUI extends Control

@export
var tower_name_label: Label

@export
var upgrade_button_0: UpgradeTowerButton

@export
var upgrade_button_1: UpgradeTowerButton

@export
var sell_button: Button

signal upgrade_tower(index: int)
signal sell_tower

func disable_upgrades():
	upgrade_button_0.disabled = true
	upgrade_button_0.disable_button()

	upgrade_button_1.disabled = true
	upgrade_button_1.disable_button()

func set_upgrade_levels(tower: Tower):
	upgrade_button_0.disabled = false
	upgrade_button_0.set_upgrade_level(tower)

	upgrade_button_1.disabled = false
	upgrade_button_1.set_upgrade_level(tower)

func update_affordability(new_money: int):
	if upgrade_button_0:
		upgrade_button_0.update_affordability(new_money)

	if upgrade_button_1:
		upgrade_button_1.update_affordability(new_money)

func set_tower(tower: Tower):
	tower_name_label.text = tower.tower_name

	upgrade_button_0.set_upgrade_level(tower)
	upgrade_button_1.set_upgrade_level(tower)

func _on_upgrade_button_upgrade_tower(index: int):
	upgrade_tower.emit(index)

func _on_sell_button_pressed():
	sell_tower.emit()
