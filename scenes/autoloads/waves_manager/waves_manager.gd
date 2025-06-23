extends Node

enum State { DISABLED, WAITING, SENDING }

const LAST_WAVE: int = 10

var boss_enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_boss.tscn")
var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_1.tscn")
var wave_collection: WaveCollection = preload("res://resources/waves/waves_path0.tres")

var _state_factory := WavesManagerStateFactory.new()
var _current_state: WavesManagerState = null

var _wave_number := 0

signal waves_began
signal wave_sent(wave: Wave)

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
	if _wave_number == 0:
		waves_began.emit()

	_wave_number += 1

	var wave := _get_next()
	if wave == null:
		print("No more waves to send!")
		return null

	print("Sending wave " + str(_wave_number))

	wave.number = _wave_number

	wave_sent.emit(wave)

	if _wave_number <= wave_collection.count():
		print("Using " + str(wave.resource_path) + " resource")

	return wave

func _get_next() -> Wave:
	if _wave_number >= LAST_WAVE:
		return null

	if _wave_number <= wave_collection.count():
		return wave_collection.get_wave(_wave_number)

	var dummy_wave := Wave.new()

	var is_boss_wave := _wave_number % 5 == 0
	dummy_wave.enemy = boss_enemy_scene if is_boss_wave else enemy_scene
	dummy_wave.spawn_count = int(_wave_number / 5.0) if is_boss_wave else _wave_number

	return dummy_wave
