class_name GameUI extends Control

@export var tower_manager: TowerManager

@onready var bank: BankManager = %BankManager
@onready var path: Path = %PathWaypoints

@onready var money_amount = $ColorRect/MoneyLabel/Amount
@onready var lives_amount = $ColorRect/LivesLabel/Amount
@onready var wave_number_label = $ColorRect/WaveLabel/Number
@onready var upgrade_button: UpgradeTowerButton = $ColorRect/SelectedTowerButtons/UpgradeButton
@onready var sell_button = $ColorRect/SelectedTowerButtons/SellButton
@onready var cancel_button = $ColorRect/CancelButton

signal tower_placing(tower: Tower)
signal tower_placing_cancelled
signal tower_placed(tower: Tower)

signal tower_selected(tower: Tower)

signal tower_upgrade_start(tower: Tower, next_level: TowerLevel)
signal tower_upgrade_finish(tower: Tower, next_level: TowerLevel)

signal tower_sold(sell_value: int)

var placing_tower: Tower:
	set(value):
		placing_tower = value
		cancel_button.visible = placing_tower != null

var selected_tower: Tower:
	set(value):
		if selected_tower:
			selected_tower.deselect()

		selected_tower = value

		if value:
			print("Showing buttons")
			upgrade_button.show()
			upgrade_button.set_upgrade_level(value.get_upgrade())

			sell_button.show()
		else:
			print("Hiding buttons")
			upgrade_button.hide()
			sell_button.hide()

func _ready():
	placing_tower = null
	selected_tower = null

	set_process(false)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if selected_tower:
			deselect()

		if placing_tower:
			cancel_tower_creation()

	if Input.is_action_just_pressed("tower_upgrade"):
		try_upgrade()

	if Input.is_action_just_pressed("ui_text_delete"):
		try_sell()

func try_place(tower_scene: PackedScene):
	placing_tower = tower_scene.instantiate()

	if not bank.can_afford(placing_tower.price):
		print(placing_tower.name + " purchase failed: cannot afford")
		placing_tower = null
		return false

	print("Purchasing " + placing_tower.name)

	placing_tower.path = path
	placing_tower.set_placing()
	placing_tower.hide()

	tower_placing.emit(placing_tower)

	placing_tower.on_placed.connect(_on_placing_tower_placed)

	add_child(placing_tower)

	return true

func _on_placing_tower_placed(tower: Tower):
	print("Placed new tower")

	placing_tower.on_selected.connect(_on_placing_tower_selected)
	placing_tower.on_upgrade_finish.connect(_on_placing_tower_on_upgrade_finish)

	# ensure the tower is not part of the UI anymore
	placing_tower.reparent(tower_manager, true)

	stop_tower_creation()

	tower_placed.emit(tower)

func _on_placing_tower_selected(tower: Tower):
	print("Selected " + tower.name)

	selected_tower = tower

	tower_selected.emit(tower)

func _on_placing_tower_on_upgrade_finish(tower: Tower, next_level: TowerLevel):
	print("Selected tower upgrade finished")

	upgrade_button.set_upgrade_level(tower.get_upgrade())

	tower_upgrade_finish.emit(tower, next_level)

func deselect():
	print("Deselecting tower")

	selected_tower.deselect()
	selected_tower = null

func cancel_tower_creation():
	print("Cancelling tower creation")

	placing_tower.queue_free()
	placing_tower = null

	tower_placing_cancelled.emit()

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

func try_sell():
	if not selected_tower:
		print("Tower sell failed: no tower selected")
		return false

	print("Selling tower")

	var sell_value = selected_tower.sell()

	selected_tower = null

	tower_sold.emit(sell_value)

	return true

func _on_start_game_start():
	print("Enabling game UI process")
	set_process(true)

func _on_gun_tower_button_create_tower(tower_scene:PackedScene):
	try_place(tower_scene)

func _on_slow_tower_button_create_tower(tower_scene:PackedScene):
	try_place(tower_scene)

func _on_upgrade_button_upgrade_tower(_level: TowerLevel):
	try_upgrade()

func _on_bank_manager_money_changed(new_money:int):
	if money_amount:
		money_amount.text = str(new_money)

func _on_lives_manager_lives_changed(new_lives):
	if lives_amount:
		lives_amount.text = str(new_lives)

func _on_waves_manager_wave_sent(wave_number: int):
	if wave_number_label:
		wave_number_label.text = str(wave_number)

func _on_sell_button_pressed():
	try_sell()

func _on_cancel_button_pressed():
	placing_tower.queue_free()

	stop_tower_creation()

func stop_tower_creation():
	placing_tower = null
