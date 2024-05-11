class_name TowerManager extends Node2D

@export var tower_1: PackedScene

@onready var path: Path = %PathWaypoints

signal tower_placed(tower: Tower)
signal tower_upgrade_start(tower: Tower, next_level: TowerLevel)

var new_tower: Tower = null

func _process(_delta):
	if Input.is_action_just_pressed("tower_1"):
		new_tower = tower_1.instantiate()

		new_tower.path = path
		new_tower.set_placing()
		new_tower.on_placed.connect(_on_new_tower_placed)
		new_tower.on_upgrade_start.connect(_on_new_tower_upgrade_start)

		add_child(new_tower)

	if Input.is_action_just_pressed("ui_cancel"):
		if new_tower:
			cancel_tower_creation()
			new_tower = null

func cancel_tower_creation():
	print("Cancelling tower creation")
	new_tower.queue_free()
	new_tower = null

func _on_new_tower_placed(tower: Tower):
	print("Placed new tower")
	new_tower = null

	tower_placed.emit(tower)

func _on_new_tower_upgrade_start(tower: Tower, next_level: TowerLevel):
	print("Upgrading tower")

	tower_upgrade_start.emit(tower, next_level)
