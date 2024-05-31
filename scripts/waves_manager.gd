class_name WavesManager extends Node

@export var path_manager: PathManager
@export var boss_enemy_scene: PackedScene
@export var enemy_scene: PackedScene

@export_range(10, 50)
var last_wave: int = 10

var wave_number: int = 0

@export
var wave_collection: WaveCollection

signal wave_sent(wave: Wave)

func _ready():
	set_process(false)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		next()

func get_next() -> Wave:
	if wave_number >= last_wave:
		return null

	if wave_number <= wave_collection.count():
		return wave_collection.get_wave(wave_number)

	var dummy_wave := Wave.new()

	var is_boss_wave := wave_number % 5 == 0
	dummy_wave.enemy = boss_enemy_scene if is_boss_wave else enemy_scene
	dummy_wave.spawn_count = int(wave_number / 5.0) if is_boss_wave else wave_number

	return dummy_wave

func next():
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
		var enemy = path_manager.spawn_enemy(wave.enemy)

		for e in wave.enhancements:
			e.act(enemy)

		await get_tree().create_timer(1.0 / wave.spawn_frequency).timeout

func _on_start_game_start(_path_index: int):
	print("Enabling waves manager")
	set_process(true)
