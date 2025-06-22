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

var _money_from_bank := 0

func _ready() -> void:
	if not Engine.is_editor_hint():
		BankManager.money_changed.connect(_on_bank_manager_money_changed)

		TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
		TowerEvents.tower_deselected.connect(_on_tower_deselected)

		TowerEvents.tower_upgrade_started.connect(_on_tower_upgrade_started)
		TowerEvents.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

func _on_bank_manager_money_changed(new_money: int) -> void:
	_money_from_bank = new_money

	update_affordability()

func disable_upgrades() -> void:
	upgrade_button_0.disabled = true
	upgrade_button_0.disable_button(false)

	upgrade_button_1.disabled = true
	upgrade_button_1.disable_button(false)

func update_affordability() -> void:
	if upgrade_button_0:
		upgrade_button_0.update_affordability(_money_from_bank)

	if upgrade_button_1:
		upgrade_button_1.update_affordability(_money_from_bank)

func set_tower(tower: Tower):
	tower_name_label.text = tower.tower_name if tower else ""

	upgrade_button_0.set_upgrade_level(tower)
	upgrade_button_1.set_upgrade_level(tower)

	sell_button.set_tower(tower)

func _on_selected_tower_changed(new_tower: Tower, _old_tower: Tower) -> void:
	set_tower(new_tower)
	update_affordability()

func _on_tower_deselected() -> void:
	set_tower(null)
	update_affordability()

func _on_tower_upgrade_started(_tower: Tower, _next_level: TowerLevel) -> void:
	disable_upgrades()

func _on_tower_upgrade_finished(tower: Tower, _next_level: TowerLevel) -> void:
	set_tower(tower)

func _on_upgrade_button_upgrade_tower(index: int) -> void:
	TowerEvents.emit_upgrade_tower(index)

func _on_target_mode_options_item_selected(index: int) -> void:
	TowerEvents.emit_target_mode_changed(index)

func _on_sell_button_sell_tower() -> void:
	TowerEvents.emit_tower_sold()
