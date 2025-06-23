extends Node

const LAST_WAVE: int = 10

var boss_enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_boss.tscn")
var enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_1.tscn")
var wave_collection: WaveCollection = preload("res://resources/waves/waves_path0.tres")

var wave_number := 0

signal waves_began
signal wave_sent(wave: Wave)

func _ready():
	GameEvents.game_started.connect(_on_game_events_game_started)

	set_process(false)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		next()

func _on_game_events_game_started(_path_index: int) -> void:
	start_game()

func get_next() -> Wave:
	if wave_number >= LAST_WAVE:
		return null

	if wave_number <= wave_collection.count():
		return wave_collection.get_wave(wave_number)

	var dummy_wave := Wave.new()

	var is_boss_wave := wave_number % 5 == 0
	dummy_wave.enemy = boss_enemy_scene if is_boss_wave else enemy_scene
	dummy_wave.spawn_count = int(wave_number / 5.0) if is_boss_wave else wave_number

	return dummy_wave

func next():
	if wave_number == 0:
		waves_began.emit()

	wave_number += 1

	var wave := get_next()
	if wave == null:
		print("No more waves to send!")
		return

	print("Sending wave " + str(wave_number))

	wave.number = wave_number

	wave_sent.emit(wave)

	if wave_number <= wave_collection.count():
		print("Using " + str(wave.resource_path) + " resource")

	for i in range(wave.spawn_count):
		var enemy := EnemyManager.spawn_enemy(wave.enemy)

		for e in wave.enhancements:
			e.act(enemy)

		await get_tree().create_timer(1.0 / wave.spawn_frequency).timeout

func start_game() -> void:
	# HIGH: implement a node-based state machine. Do this for as many nodes in
	# the game as possible!!
	print("Enabling waves manager")
	set_process(true)
