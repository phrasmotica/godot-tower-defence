class_name CreateTowerButton extends Button

@export var tower: PackedScene
@export var action_name: StringName

@onready var description = $TowerDescription
@onready var description_text = $TowerDescription/Label

signal create_tower(tower_scene: PackedScene)

func _ready():
	var dummy_tower: Tower = tower.instantiate()

	# prefer this to a tooltip so that we can control its appearance
	# by mouse enter/exit events rather than by the mouse being idle
	description_text.text = dummy_tower.tower_description

	description.hide()

func create():
	description.hide()
	create_tower.emit(tower)

func _process(_delta):
	if Input.is_action_just_pressed(action_name):
		print("Creating tower via shortcut")
		create()

func _on_pressed():
	print("Creating tower via button")
	create()

func _on_mouse_entered():
	description.show()

func _on_mouse_exited():
	description.hide()
