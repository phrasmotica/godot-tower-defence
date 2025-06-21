@tool
class_name GameUI extends Control

enum State { ENABLED, DISABLED, CREATING_TOWER, PLACING_TOWER }

@export
var path_manager: PathManager

@export
var game_tint: ColorRect

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

signal selected_tower_handled

signal next_tower
signal previous_tower
signal deselect_tower

signal tower_target_mode_changed(index: int)

signal upgrade_tower(index: int)

signal sell_tower

var _state_factory := GameUIStateFactory.new()
var _current_state: GameUIState = null

func _ready():
	if Engine.is_editor_hint():
		return

	BankManager.money_changed.connect(_on_bank_manager_money_changed)

	LivesManager.lives_changed.connect(_on_lives_manager_lives_changed)

	WavesManager.wave_sent.connect(_on_waves_manager_wave_sent)

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := GameUIStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		tower_ui,
		create_tower_ui,
		path_manager)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "GameUIStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func emit_tower_placing(tower: Tower) -> void:
	tower_placing.emit(tower)

func emit_tower_placed(tower: Tower) -> void:
	tower_placed.emit(tower)

func emit_next_tower() -> void:
	next_tower.emit()

func emit_previous_tower() -> void:
	previous_tower.emit()

func emit_deselect_tower() -> void:
	deselect_tower.emit()

func _on_start_game_start(_path_index: int):
	switch_state(State.ENABLED)

	create_tower_ui.start_game()

func _on_bank_manager_money_changed(new_money: int):
	score_ui.set_money(new_money)

	create_tower_ui.update_affordability(new_money)
	tower_ui.update_affordability(new_money)

func _on_lives_manager_lives_changed(new_lives: int):
	score_ui.set_lives(new_lives)

func _on_waves_manager_wave_sent(wave: Wave):
	score_ui.set_wave(wave)

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

	# allows tower upgrade buttons to update their state
	BankManager.emit_money_changed()

func animate_show_ui():
	animation_player.play("show_tower_ui")

func set_tower(tower: Tower):
	print("Updating selected tower UI")

	tower_ui.set_tower(tower)

	if tower:
		tower.reparent(self, true)

		game_tint.show()
	else:
		game_tint.hide()

func animate_hide_ui():
	animation_player.play("hide_tower_ui")

func hide_ui():
	print("Hiding selected tower UI")

func _on_create_tower_ui_create_tower(tower_scene: PackedScene) -> void:
	switch_state(State.CREATING_TOWER, GameUIStateData.build().with_tower_scene(tower_scene))

func _on_tower_ui_upgrade_tower(index: int):
	upgrade_tower.emit(index)

func _on_tower_ui_sell_tower():
	sell_tower.emit()

func _on_tower_ui_target_mode_changed(index: int):
	tower_target_mode_changed.emit(index)
