class_name GameUI extends Control

@onready var money_amount = $ColorRect/MoneyLabel/Amount
@onready var lives_amount = $ColorRect/LivesLabel/Amount
@onready var wave_number_label = $ColorRect/WaveLabel/Number
@onready var upgrade_button = $ColorRect/SelectedTowerButtons/UpgradeButton
@onready var sell_button = $ColorRect/SelectedTowerButtons/SellButton
@onready var cancel_button = $ColorRect/CancelButton

signal buy_gun_tower_button
signal upgrade_selected_tower
signal sell_selected_tower

var placing_tower: Tower = null

func _ready():
	upgrade_button.hide()
	sell_button.hide()

func _on_gun_tower_button_pressed():
	print("Buying gun tower from UI")

	buy_gun_tower_button.emit()

func _on_bank_manager_money_changed(new_money:int):
	if money_amount:
		money_amount.text = str(new_money)

func _on_lives_manager_lives_changed(new_lives):
	if lives_amount:
		lives_amount.text = str(new_lives)

func _on_waves_manager_wave_sent(wave_number: int):
	if wave_number_label:
		wave_number_label.text = str(wave_number)

func _on_upgrade_button_pressed():
	print("Upgrading selected tower")

	upgrade_selected_tower.emit()

func _on_sell_button_pressed():
	print("Selling selected tower")

	sell_selected_tower.emit()

func _on_towers_tower_selected(tower: Tower):
	upgrade_button.show()
	upgrade_button.disabled = tower.get_upgrade() == null

	sell_button.show()

func _on_towers_tower_deselected():
	upgrade_button.hide()
	sell_button.hide()

func _on_towers_tower_upgrade_start(_tower:Tower, _next_level:TowerLevel):
	upgrade_button.disabled = true

func _on_towers_tower_upgrade_finish(tower:Tower, _next_level:TowerLevel):
	upgrade_button.disabled = tower.get_upgrade() == null

func _on_towers_tower_placing(tower: Tower):
	placing_tower = tower

	add_child(tower)

	# TODO: parent the tower node to the tower manager once it's placed

	cancel_button.show()

func _on_towers_tower_placed(_tower: Tower):
	stop_tower_creation()

func _on_towers_tower_placing_cancelled():
	# tower manager has already freed placing_tower

	stop_tower_creation()

func _on_cancel_button_pressed():
	# need to free placing_tower ourselves
	placing_tower.queue_free()
	placing_tower = null

	stop_tower_creation()

func stop_tower_creation():
	cancel_button.hide()
