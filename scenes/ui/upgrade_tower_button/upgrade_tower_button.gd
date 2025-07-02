class_name UpgradeTowerButton extends Button

enum State { DISABLED, ENABLED, UNAVAILABLE }

@export
var action_name: StringName

@export
var upgrade_index := 0

@export
var align_tooltip_bottom := false:
	set(value):
		align_tooltip_bottom = value

		if appearance:
			appearance.realign_tooltip()

@onready
var appearance: UpgradeTowerButtonAppearance = %Appearance

var _state_factory := UpgradeTowerButtonStateFactory.new()
var _current_state: UpgradeTowerButtonState = null

func _ready() -> void:
	switch_state(State.UNAVAILABLE)

func switch_state(state: State, state_data := UpgradeTowerButtonStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "UpgradeTowerButtonStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)
