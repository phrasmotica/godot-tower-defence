class_name GameUI extends PanelContainer

enum State { ENABLED, DISABLED, CREATING_TOWER, PLACING_TOWER }

@onready
var appearance: GameUIAppearance = %Appearance

var _state_factory := GameUIStateFactory.new()
var _current_state: GameUIState = null

func _ready() -> void:
	switch_state(State.DISABLED)

func switch_state(state: State, state_data := GameUIStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "GameUIStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)
