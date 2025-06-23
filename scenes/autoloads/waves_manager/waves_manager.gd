extends Node

enum State { DISABLED, WAITING }

const LAST_WAVE_INDEX: int = 9

var boss_enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_boss.tscn")
var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_1.tscn")
var wave_collection: WaveCollection = preload("res://resources/waves/waves_path0.tres")

var _state_factory := WavesManagerStateFactory.new()
var _current_state: WavesManagerState = null

var _wave_index := -1

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
	switch_state(State.WAITING)

func next() -> Wave:
	if _wave_index == -1:
		WaveEvents.emit_waves_began()

	var wave := _get_next()
	if wave == null:
		print("No more waves to send!")
		return null

	wave.number = _wave_index + 1

	return wave

func _get_next() -> Wave:
	if _wave_index >= LAST_WAVE_INDEX:
		return null

	_wave_index += 1

	var wave_from_collection := wave_collection.get_wave(_wave_index)

	if wave_from_collection != null:
		return wave_from_collection

	var dummy_wave := Wave.new()

	var is_boss_wave := _wave_index % 5 == 4
	dummy_wave.enemy = boss_enemy_scene if is_boss_wave else enemy_scene
	dummy_wave.spawn_count = int(_wave_index / 5.0) if is_boss_wave else _wave_index

	return dummy_wave
