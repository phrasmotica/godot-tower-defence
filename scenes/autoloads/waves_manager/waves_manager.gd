extends Node

enum State { DISABLED, WAITING }

const LAST_WAVE_INDEX: int = 4

var _state_factory := WavesManagerStateFactory.new()
var _current_state: WavesManagerState = null

var _wave_factory := WaveFactory.new(LAST_WAVE_INDEX)

func _ready() -> void:
	GameEvents.game_started.connect(_on_game_events_game_started)

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := WavesManagerStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "WavesManagerStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _on_game_events_game_started(_path_index: int) -> void:
	_wave_factory.restart()

	switch_state(State.WAITING)

func get_next_wave() -> Wave:
	if _wave_factory.is_waiting_to_start():
		WaveEvents.emit_waves_began()

	var wave := _wave_factory.create()
	if wave == null:
		print("No more waves to send!")

	return wave
