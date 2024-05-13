class_name WavesManager extends Node

@onready var path = %PathWaypoints

@export var enemy_scene: PackedScene

var wave_number = 0

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		next()

func next():
	wave_number += 1

	for i in range(wave_number):
		path.spawn_enemy(enemy_scene)
		await get_tree().create_timer(1.0).timeout
