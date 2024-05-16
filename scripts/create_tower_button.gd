class_name CreateTowerButton extends Button

@export var tower: PackedScene
@export var action_name: StringName

signal create_tower(tower_scene: PackedScene)

func create():
	create_tower.emit(tower)

func _process(_delta):
	if Input.is_action_just_pressed(action_name):
		print("Creating tower via shortcut")
		create()

func _on_pressed():
	print("Creating tower via button")
	create()
