@tool
class_name CreateTowerButton extends Button

@export var tower: PackedScene
@export var action_name: StringName

@export
var tooltip: Control

@export
var name_text: Label

@export
var price_text: Label

@export
var description_text: Label

@export
var show_tooltip := false:
	set(value):
		tooltip.visible = value

	get:
		return tooltip.visible

var tower_price := 0

var original_icon: Texture2D

var is_creating_mode := false:
	set(value):
		is_creating_mode = value

		if is_creating_mode:
			# TODO: button should not respond to being clicked. Setting mouse
			# filter to IGNORE also prevents the tower being put back, though.
			# Fix this by rendering a separate Control node on top of the button
			# while in creating mode...
			tooltip.hide()
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
		price_text.text = "Price: " + str(dummy_tower.price)
		description_text.text = dummy_tower.tower_description

	mouse_filter = MOUSE_FILTER_IGNORE
	set_process(false)

func start_game():
	mouse_filter = MOUSE_FILTER_STOP
	set_process(true)

func create():
	is_creating_mode = true

	create_tower.emit(tower)

func update_affordability(money: int):
	disabled = tower_price > money

func cancel():
	is_creating_mode = false

	cancel_tower.emit()

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed(action_name):
		print("Creating tower via shortcut")
		create()

func _on_pressed():
	if is_creating_mode:
		cancel()
		tooltip.show()
		return

	print("Creating tower via button")
	create()

func _on_mouse_entered():
	if not disabled:
		if is_creating_mode:
			cancel()

		tooltip.show()

func _on_mouse_exited():
	tooltip.hide()
