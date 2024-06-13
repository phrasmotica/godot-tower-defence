@tool
class_name GameUI extends Control

@export
var path_manager: PathManager

@export
var game_tint: ColorRect

@export
var bank: BankManager

@export
var money_label: AmountLabel

@export
var lives_label: AmountLabel

@export
var wave_label: AmountLabel

@export
var tower_name_label: Label

@export
var create_tower_buttons: Array[CreateTowerButton]

@export
var upgrade_button_0: UpgradeTowerButton

@export
var upgrade_button_1: UpgradeTowerButton

@export
var sell_button: Button

@export
var cancel_button: Button

signal tower_placing(tower: Tower)
signal tower_placing_cancelled
signal tower_placed(tower: Tower)

signal tower_selected(tower: Tower)

signal next_tower
signal previous_tower
signal deselect_tower

signal upgrade_tower(index: int)

signal tower_upgrade_finish(tower: Tower, next_level: TowerLevel)

signal sell_tower

var current_tower_scene_id := 0

var placing_tower: Tower:
	set(value):
		placing_tower = value
		cancel_button.visible = placing_tower != null

func _ready():
	if Engine.is_editor_hint():
		return

	placing_tower = null
	current_tower_scene_id = 0

	hide_ui()

	set_process(false)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed("ui_cancel"):
		deselect_tower.emit()

		if placing_tower:
			cancel_tower_creation()

	if Input.is_action_just_pressed("next_tower"):
		next_tower.emit()

	if Input.is_action_just_pressed("previous_tower"):
		previous_tower.emit()

	if Input.is_action_just_pressed("ui_text_delete"):
		sell_tower.emit()

func try_place(tower_scene: PackedScene):
	var new_id := tower_scene.get_instance_id()

	if current_tower_scene_id == new_id:
		print("Already placing tower with ID " + str(new_id))
		return

	if placing_tower:
		cancel_tower_creation()

	placing_tower = tower_scene.instantiate()
	current_tower_scene_id = new_id

	if not bank.can_afford(placing_tower.price):
		print(placing_tower.name + " purchase failed: cannot afford")
		placing_tower = null
		current_tower_scene_id = 0
		return false

	print("Purchasing " + placing_tower.name)

	placing_tower.path_manager = path_manager
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

	tower_placed.emit(tower)

	stop_tower_creation()

func _on_placing_tower_selected(tower: Tower):
	print("Selected " + tower.name)

	tower_selected.emit(tower)

func _on_placing_tower_on_upgrade_finish(tower: Tower, next_level: TowerLevel):
	print("Selected tower upgrade finished")

	upgrade_button_0.disabled = false
	upgrade_button_0.set_upgrade_level(tower)

	upgrade_button_1.disabled = false
	upgrade_button_1.set_upgrade_level(tower)

	tower_upgrade_finish.emit(tower, next_level)

func cancel_tower_creation():
	print("Cancelling tower creation")

	placing_tower.queue_free()
	placing_tower = null
	current_tower_scene_id = 0

	tower_placing_cancelled.emit()

func _on_start_game_start(_path_index: int):
	print("Enabling game UI process")
	set_process(true)

	for ctb in create_tower_buttons:
		ctb.enable_button()

func _on_gun_tower_button_create_tower(tower_scene:PackedScene):
	try_place(tower_scene)

func _on_slow_tower_button_create_tower(tower_scene:PackedScene):
	try_place(tower_scene)

func _on_cannon_tower_button_create_tower(tower_scene:PackedScene):
	try_place(tower_scene)

func _on_upgrade_button_upgrade_tower(index: int):
	upgrade_tower.emit(index)

func _on_bank_manager_money_changed(new_money:int):
	if money_label:
		money_label.amount = new_money

	for ctb in create_tower_buttons:
		ctb.update_affordability(new_money)

	if upgrade_button_0:
		upgrade_button_0.update_affordability(new_money)

	if upgrade_button_1:
		upgrade_button_1.update_affordability(new_money)

func _on_lives_manager_lives_changed(new_lives):
	if lives_label:
		lives_label.amount = new_lives

func _on_waves_manager_wave_sent(wave: Wave):
	if wave_label:
		wave_label.amount = wave.number
		wave_label.tooltip_text = wave.description

func _on_sell_button_pressed():
	sell_tower.emit()

func _on_cancel_area_area_entered(_area:Area2D):
	placing_tower.queue_free()

	stop_tower_creation()

func stop_tower_creation():
	placing_tower = null
	current_tower_scene_id = 0

func _on_towers_tower_upgrade_start(_tower: Tower, _next_level: TowerLevel):
	upgrade_button_0.disabled = true
	upgrade_button_0.disable_button()

	upgrade_button_1.disabled = true
	upgrade_button_1.disable_button()

func _on_towers_selected_tower_changed(tower: Tower):
	handle_selected_tower_changed(tower)

func _on_towers_tower_deselected():
	handle_selected_tower_changed(null)

func _on_towers_tower_sold(_sell_value:int):
	hide_ui()

func handle_selected_tower_changed(tower: Tower):
	if tower:
		show_ui(tower)
	else:
		hide_ui()

func show_ui(tower: Tower):
	print("Showing selected tower UI")

	tower_name_label.text = tower.tower_name

	upgrade_button_0.show()
	upgrade_button_0.set_upgrade_level(tower)

	upgrade_button_1.show()
	upgrade_button_1.set_upgrade_level(tower)

	sell_button.show()

	game_tint.show()

func hide_ui():
	print("Hiding selected tower UI")

	tower_name_label.text = ""

	upgrade_button_0.hide()
	upgrade_button_1.hide()
	sell_button.hide()

	game_tint.hide()
