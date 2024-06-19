@tool
class_name GameUI extends Control

@export
var path_manager: PathManager

@export
var game_tint: ColorRect

@export
var bank: BankManager

@export
var score_ui: ScoreUI

@export
var create_tower_ui: CreateTowerUI

@export
var tower_ui: TowerUI

@export
var animation_player: AnimationPlayer

signal tower_placing(tower: Tower)
signal tower_placed(tower: Tower)

signal tower_selected(tower: Tower)
signal selected_tower_handled

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

	stop_tower_creation(false)

	set_process(false)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed("ui_cancel"):
		if placing_tower:
			stop_tower_creation(true)

			create_tower_ui.set_default_mode()
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

	create_tower_ui.set_default_mode_except(tower_scene)

	if placing_tower:
		stop_tower_creation(true)

	placing_tower = tower_scene.instantiate()
	current_tower_scene_id = new_id

	if not bank.can_afford(placing_tower.price):
		print(placing_tower.name + " purchase failed: cannot afford")

		stop_tower_creation(false)

		return false

	print("Purchasing " + placing_tower.name)

	placing_tower.path_manager = path_manager
	placing_tower.set_placing()
	placing_tower.hide()

	placing_tower.on_placed.connect(_on_placing_tower_placed)

	add_child(placing_tower)

	tower_placing.emit(placing_tower)

	return true

func _on_placing_tower_placed(tower: Tower):
	print("Placed new tower")

	placing_tower.on_selected.connect(_on_placing_tower_selected)
	placing_tower.on_upgrade_finish.connect(_on_placing_tower_on_upgrade_finish)

	tower_placed.emit(tower)

	stop_tower_creation(false)

	create_tower_ui.set_default_mode()

func _on_placing_tower_selected(tower: Tower):
	print("Selected " + tower.name)

	tower_selected.emit(tower)

func _on_placing_tower_on_upgrade_finish(tower: Tower, next_level: TowerLevel):
	print("Selected tower upgrade finished")

	tower_ui.set_tower(tower)

	tower_upgrade_finish.emit(tower, next_level)

func _on_start_game_start(_path_index: int):
	print("Enabling game UI process")
	set_process(true)

	create_tower_ui.start_game()

func _on_bank_manager_money_changed(new_money: int):
	score_ui.set_money(new_money)

	create_tower_ui.update_affordability(new_money)
	tower_ui.update_affordability(new_money)

func _on_lives_manager_lives_changed(new_lives: int):
	score_ui.set_lives(new_lives)

func _on_waves_manager_wave_sent(wave: Wave):
	score_ui.set_wave(wave)

func stop_tower_creation(free: bool):
	if free and placing_tower:
		placing_tower.queue_free()

	placing_tower = null
	current_tower_scene_id = 0

func _on_towers_tower_upgrade_start(_tower: Tower, _next_level: TowerLevel):
	tower_ui.disable_upgrades()

func _on_towers_selected_tower_changed(tower: Tower, was_unselected: bool):
	handle_selected_tower_changed(tower, was_unselected)

func _on_towers_tower_deselected():
	handle_selected_tower_changed(null, false)

func handle_selected_tower_changed(tower: Tower, was_unselected: bool):
	set_tower(tower)

	if tower:
		if was_unselected:
			animate_show_ui()
	else:
		animate_hide_ui()

	selected_tower_handled.emit()

func animate_show_ui():
	animation_player.play("show_tower_ui")

func set_tower(tower: Tower):
	print("Updating selected tower UI")

	if tower:
		tower.reparent(self, true)

		tower_ui.set_tower(tower)

		game_tint.show()
	else:
		game_tint.hide()

func animate_hide_ui():
	animation_player.play("hide_tower_ui")

func hide_ui():
	print("Hiding selected tower UI")

func _on_create_tower_ui_create_tower(tower_scene:PackedScene):
	try_place(tower_scene)

func _on_create_tower_ui_cancel_tower():
	stop_tower_creation(true)

func _on_tower_ui_upgrade_tower(index: int):
	upgrade_tower.emit(index)

func _on_tower_ui_sell_tower():
	sell_tower.emit()

func _on_path_manager_mouse_validity_changed(is_valid: bool):
	if placing_tower:
		placing_tower.is_valid_location = is_valid

		if is_valid:
			placing_tower.show_visualiser()
			placing_tower.set_default_look()
		else:
			placing_tower.hide_visualiser()
			placing_tower.set_error_look()

func _on_path_manager_valid_area_clicked():
	if placing_tower:
		placing_tower.try_place()
