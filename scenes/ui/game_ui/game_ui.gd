@tool
class_name GameUI extends Control

enum State { ENABLED, DISABLED, CREATING_TOWER, PLACING_TOWER }

@export
var path_manager: PathManager

@export
var game_tint: ColorRect

@export
var create_tower_ui: CreateTowerUI

@export
var tower_ui: TowerUI

@export
var animation_player: AnimationPlayer

signal selected_tower_handled

signal tower_target_mode_changed(index: int)

signal upgrade_tower(index: int)

signal sell_tower

var _state_factory := GameUIStateFactory.new()
var _current_state: GameUIState = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	GameEvents.game_started.connect(_on_game_events_game_started)

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

func _on_game_events_game_started(_path_index: int) -> void:
	switch_state(State.ENABLED)

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
