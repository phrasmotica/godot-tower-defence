@tool
class_name GameUI extends Control

enum State { ENABLED, DISABLED, CREATING_TOWER, PLACING_TOWER }

@onready
var appearance: GameUIAppearance = %Appearance

@onready
var create_tower_ui: CreateTowerUI = %CreateTowerUI

@onready
var tower_ui: TowerUI = %TowerUI

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
		appearance,
		tower_ui,
		create_tower_ui)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "GameUIStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _on_game_events_game_started(_path_index: int) -> void:
	switch_state(State.ENABLED)
