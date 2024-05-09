class_name TowerManager extends Node2D

@export var tower_1: PackedScene

@onready var path: Path = %PathWaypoints

var new_tower: Tower = null

func _process(_delta):
	if Input.is_action_just_pressed("tower_1"):
		new_tower = tower_1.instantiate()

		new_tower.set_placing()
		new_tower.on_placed.connect(_on_new_tower_placed)

		add_child(new_tower)

func _on_new_tower_placed(_tower: Tower):
	print("Placed new tower")
	new_tower = null
