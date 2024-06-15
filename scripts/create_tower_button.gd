@tool
class_name CreateTowerButton extends Button

@export var tower: PackedScene
@export var action_name: StringName

@export
var description: Control

@export
var name_text: Label

@export
var description_text: Label

@export
var show_description := false:
	set(value):
		description.visible = value

	get:
		return description.visible

var tower_price := 0

var original_icon: Texture2D

var is_creating_mode := false:
	set(value):
		is_creating_mode = value

		if is_creating_mode:
			description.hide()
			icon = null
		else:
			icon = original_icon

signal create_tower(tower_scene: PackedScene)
signal cancel_tower

func _ready():
	if Engine.is_editor_hint():
		return

	if tower:
		original_icon = icon

		var dummy_tower: Tower = tower.instantiate()

		tower_price = dummy_tower.price

		# prefer this to a tooltip so that we can control its appearance
		# by mouse enter/exit events rather than by the mouse being idle
		name_text.text = dummy_tower.tower_name
		description_text.text = dummy_tower.tower_description
	else:
		disabled = true

	description.hide()

	disable_button()

func enable_button():
	set_process(true)

func disable_button():
	set_process(false)

func create():
	is_creating_mode = true

	create_tower.emit(tower)

func update_affordability(money: int):
	if tower_price > money:
		disabled = true
		disable_button()
	else:
		disabled = false
		enable_button()

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed(action_name):
		print("Creating tower via shortcut")
		create()

func _on_pressed():
	print("Creating tower via button")
	create()

func _on_mouse_entered():
	if not disabled:
		if is_creating_mode:
			is_creating_mode = false

			cancel_tower.emit()

		description.show()

func _on_mouse_exited():
	description.hide()
