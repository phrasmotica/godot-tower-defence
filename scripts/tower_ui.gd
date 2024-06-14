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

@export
var cancel_button: Button

# TODO: export this to editor
var is_cancel_mode := false:
	set(value):
		is_cancel_mode = value

		if is_cancel_mode:
			hide_ui()
		else:
			show_ui()

		cancel_button.visible = is_cancel_mode

signal cancel_tower
signal upgrade_tower(index: int)
signal sell_tower

func show_cancel_button():
	cancel_button.show()

func hide_cancel_button():
	cancel_button.hide()

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

	show_ui()

func show_ui():
	tower_name_label.show()

	upgrade_button_0.show()
	upgrade_button_1.show()
	sell_button.show()

func hide_ui():
	tower_name_label.hide()

	upgrade_button_0.hide()
	upgrade_button_1.hide()
	sell_button.hide()

func _on_cancel_area_area_entered(_area: Area2D):
	cancel_tower.emit()

func _on_upgrade_button_upgrade_tower(index: int):
	upgrade_tower.emit(index)

func _on_sell_button_pressed():
	sell_tower.emit()
