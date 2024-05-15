class_name GameUI extends Control

@onready var bank: BankManager = %BankManager

@onready var money_amount = $ColorRect/MoneyLabel/Amount
@onready var lives_amount = $ColorRect/LivesLabel/Amount
@onready var wave_number_label = $ColorRect/WaveLabel/Number
@onready var upgrade_button = $ColorRect/SelectedTowerButtons/UpgradeButton
@onready var sell_button = $ColorRect/SelectedTowerButtons/SellButton
@onready var cancel_button = $ColorRect/CancelButton

signal buy_gun_tower_button
signal sell_selected_tower

signal tower_upgrade_start(tower: Tower, next_level: TowerLevel)

var placing_tower: Tower = null
var selected_tower: Tower = null

func _ready():
	upgrade_button.hide()
	sell_button.hide()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if selected_tower:
			deselect()

	if Input.is_action_just_pressed("tower_upgrade"):
		try_upgrade()

func deselect():
	print("Deselecting tower")

	selected_tower.deselect()
	selected_tower = null

	upgrade_button.hide()
	sell_button.hide()

func try_upgrade():
	if not selected_tower:
		print("Tower upgrade failed: no tower selected")
		return false

	var next_level = selected_tower.get_upgrade()
	if not next_level:
		print("Tower upgrade failed: no more upgrades")
		return false

	if selected_tower.is_upgrading():
		print("Tower upgrade failed: already upgrading")
		return false

	if not bank.can_afford(next_level.price):
		print("Tower upgrade failed: cannot afford")
		return false

	print("Upgrading tower")

	upgrade_button.disabled = true

	selected_tower.upgrade()
	tower_upgrade_start.emit(selected_tower, next_level)

	return true

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
	try_upgrade()

func _on_sell_button_pressed():
	print("Selling selected tower")

	sell_selected_tower.emit()

func _on_towers_tower_selected(tower: Tower):
	upgrade_button.show()
	upgrade_button.disabled = tower.get_upgrade() == null

	sell_button.show()

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
