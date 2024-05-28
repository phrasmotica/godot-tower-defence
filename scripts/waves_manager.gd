class_name WavesManager extends Node

@onready var path = %PathWaypoints

@export var boss_enemy_scene: PackedScene
@export var enemy_scene: PackedScene

@export_range(10, 50)
var last_wave: int = 10

var wave_number: int = 0

@export
var wave_collection: WaveCollection

signal wave_sent(wave_number: int)

func _ready():
	set_process(false)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		next()

func next():
	if wave_number >= last_wave:
		print("No more waves to send!")
		return

	wave_number += 1
	print("Sending wave " + str(wave_number))

	wave_sent.emit(wave_number)

	var is_boss_wave := wave_number % 5 == 0
	var spawn_count := wave_number / 5 if is_boss_wave else wave_number
	var spawn_frequency := 1.0
	var enemy_to_spawn := boss_enemy_scene if is_boss_wave else enemy_scene

	if wave_number <= wave_collection.count():
		var wave := wave_collection.get_wave(wave_number)

		print("Using " + str(wave.resource_path) + " resource")

		spawn_count = wave.spawn_count
		spawn_frequency = wave.spawn_frequency
		enemy_to_spawn = wave.enemy

	for i in range(spawn_count):
		path.spawn_enemy(enemy_to_spawn)
		await get_tree().create_timer(1.0 / spawn_frequency).timeout

func _on_start_game_start():
	print("Enabling waves manager")
	set_process(true)
