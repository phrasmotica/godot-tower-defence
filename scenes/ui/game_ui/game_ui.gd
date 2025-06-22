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

var _state_factory := GameUIStateFactory.new()
var _current_state: GameUIState = null

var _is_animated_in := false

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	GameEvents.game_started.connect(_on_game_events_game_started)

	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)
	TowerEvents.tower_sold.connect(_on_tower_sold)

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

func _on_selected_tower_changed(_tower: Tower, old_tower: Tower) -> void:
	# we assume tower is not null here
	# tower.reparent(self, true)

	game_tint.show()

	if old_tower == null:
		animate_show_ui()

func _on_tower_deselected() -> void:
	game_tint.hide()

	if _is_animated_in:
		animate_hide_ui()

func _on_tower_sold() -> void:
	game_tint.hide()

	if _is_animated_in:
		animate_hide_ui()

func animate_show_ui() -> void:
	animation_player.play("show_tower_ui")
	_is_animated_in = true

func animate_hide_ui() -> void:
	animation_player.play("hide_tower_ui")
	_is_animated_in = false

func hide_ui() -> void:
	print("Hiding selected tower UI")
