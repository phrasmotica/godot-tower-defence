class_name TowerManager extends Node2D

@export var tower_1: PackedScene

@onready var bank: BankManager = %BankManager
@onready var path: Path = %PathWaypoints

signal tower_placed(tower: Tower)
signal tower_upgrade_start(tower: Tower, next_level: TowerLevel)

signal tower_selected(tower: Tower)
signal tower_deselected
signal tower_sold

var new_tower: Tower = null
var selected_tower: Tower = null

func _process(_delta):
	if Input.is_action_just_pressed("tower_1"):
		new_tower = tower_1.instantiate()

		new_tower.path = path
		new_tower.set_placing()

		new_tower.on_placed.connect(_on_new_tower_placed)
		new_tower.on_selected.connect(_on_new_tower_selected)

		add_child(new_tower)

	if Input.is_action_just_pressed("ui_cancel"):
		if selected_tower:
			deselect()

		if new_tower:
			cancel_tower_creation()

	if Input.is_action_just_pressed("tower_upgrade"):
		try_upgrade()

	if Input.is_action_just_pressed("ui_text_delete"):
		try_sell()

func deselect():
	print("Deselecting tower")

	selected_tower.deselect()
	selected_tower = null
	tower_deselected.emit()

func cancel_tower_creation():
	print("Cancelling tower creation")
	new_tower.queue_free()
	new_tower = null

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

	upgrade()
	return true

func upgrade():
	print("Upgrading tower")

	# assumes a tower is selected and the next level is not null
	var next_level = selected_tower.upgrade()
	tower_upgrade_start.emit(selected_tower, next_level)

func try_sell():
	if not selected_tower:
		print("Tower sell failed: no tower selected")
		return false

	sell()
	return true

func sell():
	print("Selling tower")

	# assumes a tower is selected
	# TODO: gain some money from this
	selected_tower.sell()
	selected_tower = null

	tower_sold.emit()

func _on_new_tower_placed(tower: Tower):
	print("Placed new tower")
	new_tower = null

	tower_placed.emit(tower)

func _on_new_tower_selected(tower: Tower):
	print("Selected " + tower.name)

	if selected_tower:
		selected_tower.deselect()

	selected_tower = tower
	tower_selected.emit(tower)
