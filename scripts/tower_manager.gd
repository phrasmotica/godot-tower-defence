class_name TowerManager extends Node2D

@export var tower_1: PackedScene

@onready var bank: BankManager = %BankManager
@onready var path: Path = %PathWaypoints

# TODO: eventually decouple this
@onready var game_ui: GameUI = %GameUI

signal tower_placing(tower: Tower)
signal tower_placing_cancelled
signal tower_placed(tower: Tower)
signal tower_upgrade_finish(tower: Tower, next_level: TowerLevel)

signal tower_selected(tower: Tower)
signal tower_sold(sell_value: int)

var new_tower: Tower = null

func _ready():
	set_process(false)

func _process(_delta):
	# TODO: handle all of this in game_ui.gd
	if Input.is_action_just_pressed("tower_1"):
		try_place(tower_1)

	if Input.is_action_just_pressed("ui_cancel"):
		if new_tower:
			cancel_tower_creation()

	if Input.is_action_just_pressed("ui_text_delete"):
		try_sell()

func try_place(tower_scene: PackedScene):
	new_tower = tower_scene.instantiate()

	if not bank.can_afford(new_tower.price):
		print(new_tower.name + " purchase failed: cannot afford")
		return false

	print("Purchasing " + new_tower.name)

	new_tower.path = path
	new_tower.set_placing()

	tower_placing.emit(new_tower)

	new_tower.on_placed.connect(_on_new_tower_placed)
	new_tower.on_selected.connect(_on_new_tower_selected)
	new_tower.on_upgrade_finish.connect(_on_new_tower_on_upgrade_finish)

	return true

func cancel_tower_creation():
	print("Cancelling tower creation")

	new_tower.queue_free()
	new_tower = null

	tower_placing_cancelled.emit()

func _on_new_tower_on_upgrade_finish(tower: Tower, next_level: TowerLevel):
	print("Selected tower upgrade finished")

	tower_upgrade_finish.emit(tower, next_level)

func try_sell():
	if not game_ui.selected_tower:
		print("Tower sell failed: no tower selected")
		return false

	sell()
	return true

func sell():
	print("Selling tower")

	# assumes a tower is selected
	var sell_value = game_ui.selected_tower.sell()

	game_ui.selected_tower = null

	tower_sold.emit(sell_value)

func _on_new_tower_placed(tower: Tower):
	print("Placed new tower")
	new_tower = null

	tower_placed.emit(tower)

func _on_new_tower_selected(tower: Tower):
	print("Selected " + tower.name)

	if game_ui.selected_tower:
		game_ui.selected_tower.deselect()

	game_ui.selected_tower = tower
	tower_selected.emit(tower)

func _on_start_game_start():
	print("Enabling tower manager")
	set_process(true)

func _on_game_ui_buy_gun_tower_button():
	try_place(tower_1)

func _on_game_ui_sell_selected_tower():
	try_sell()
