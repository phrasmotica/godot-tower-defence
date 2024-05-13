class_name WavesManager extends Node

@onready var path = %PathWaypoints

@export var enemy_scene: PackedScene

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		path.spawn_enemy(enemy_scene)
