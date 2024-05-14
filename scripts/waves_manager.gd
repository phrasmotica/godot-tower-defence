class_name WavesManager extends Node

@onready var path = %PathWaypoints

@export var enemy_scene: PackedScene

@export_range(10, 50)
var last_wave: int = 10

var wave_number: int = 0

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

	for i in range(wave_number):
		path.spawn_enemy(enemy_scene)
		await get_tree().create_timer(1.0).timeout

func _on_start_game_start():
	print("Enabling waves manager")
	set_process(true)
