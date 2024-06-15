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
var create_tower_buttons: Array[CreateTowerButton]

@export
var tower_ui: TowerUI

@export
var animation_player: AnimationPlayer

signal tower_placing(tower: Tower)
signal tower_placed(tower: Tower)

signal tower_selected(tower: Tower)

signal next_tower
signal previous_tower
signal deselect_tower

signal upgrade_tower(index: int)

signal tower_upgrade_finish(tower: Tower, next_level: TowerLevel)

signal sell_tower

var current_tower_scene_id := 0
var placing_tower: Tower

func _ready():
	if Engine.is_editor_hint():
		return

	stop_tower_creation()

	set_process(false)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed("ui_cancel"):
		if placing_tower:
			placing_tower.queue_free()

			stop_tower_creation()

			for ctb in create_tower_buttons:
				ctb.is_creating_mode = false
		else:
			deselect_tower.emit()

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

	for ctb in create_tower_buttons:
		if ctb.tower != tower_scene:
			ctb.is_creating_mode = false

	if placing_tower:
		placing_tower.queue_free()

	placing_tower = tower_scene.instantiate()
	current_tower_scene_id = new_id

	if not bank.can_afford(placing_tower.price):
		print(placing_tower.name + " purchase failed: cannot afford")

		stop_tower_creation()

		return false

	print("Purchasing " + placing_tower.name)

	placing_tower.path_manager = path_manager
	placing_tower.set_placing()
	placing_tower.hide()

	tower_placing.emit(placing_tower)

	placing_tower.on_placed.connect(_on_placing_tower_placed)

	return true

func _on_placing_tower_placed(tower: Tower):
	print("Placed new tower")

	placing_tower.on_selected.connect(_on_placing_tower_selected)
	placing_tower.on_upgrade_finish.connect(_on_placing_tower_on_upgrade_finish)

	tower_placed.emit(tower)

	stop_tower_creation()

	for ctb in create_tower_buttons:
		ctb.is_creating_mode = false

func _on_placing_tower_selected(tower: Tower):
	print("Selected " + tower.name)

	tower_selected.emit(tower)

func _on_placing_tower_on_upgrade_finish(tower: Tower, next_level: TowerLevel):
	print("Selected tower upgrade finished")

	tower_ui.set_upgrade_levels(tower)

	tower_upgrade_finish.emit(tower, next_level)

func _on_start_game_start(_path_index: int):
	print("Enabling game UI process")
	set_process(true)

	for ctb in create_tower_buttons:
		ctb.enable_button()

func _on_tower_button_create_tower(tower_scene:PackedScene):
	try_place(tower_scene)

func _on_bank_manager_money_changed(new_money:int):
	if money_label:
		money_label.amount = new_money

	for ctb in create_tower_buttons:
		ctb.update_affordability(new_money)

	tower_ui.update_affordability(new_money)

func _on_lives_manager_lives_changed(new_lives):
	if lives_label:
		lives_label.amount = new_lives

func _on_waves_manager_wave_sent(wave: Wave):
	if wave_label:
		wave_label.amount = wave.number
		wave_label.tooltip_text = wave.description

func stop_tower_creation():
	placing_tower = null
	current_tower_scene_id = 0

func _on_towers_tower_upgrade_start(_tower: Tower, _next_level: TowerLevel):
	tower_ui.disable_upgrades()

func _on_towers_selected_tower_changed(tower: Tower, was_unselected: bool):
	handle_selected_tower_changed(tower, was_unselected)

func _on_towers_tower_deselected():
	handle_selected_tower_changed(null, false)

func handle_selected_tower_changed(tower: Tower, was_unselected: bool):
	if tower:
		show_ui(tower)

		if was_unselected:
			animate_show_ui()
	else:
		animate_hide_ui()

func animate_show_ui():
	animation_player.play("show_tower_ui")

func show_ui(tower: Tower):
	print("Showing selected tower UI")

	tower_ui.set_tower(tower)

	game_tint.show()

func animate_hide_ui():
	animation_player.play("hide_tower_ui")

func hide_ui():
	print("Hiding selected tower UI")

	tower_ui.hide_ui()

	game_tint.hide()

func _on_tower_ui_upgrade_tower(index: int):
	upgrade_tower.emit(index)

func _on_tower_ui_sell_tower():
	sell_tower.emit()

func _on_tower_button_cancel_tower():
	if placing_tower:
		placing_tower.queue_free()

		stop_tower_creation()
