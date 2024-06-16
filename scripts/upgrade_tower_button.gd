@tool
class_name UpgradeTowerButton extends Button

@export var action_name: StringName
@export var upgrade_index := 0

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

var upgrade_level: TowerLevel
var upgrade_price := 0

signal upgrade_tower(index: int)

func set_upgrade_level(tower: Tower):
	upgrade_level = tower.get_upgrade(upgrade_index)

	if upgrade_level:
		text = upgrade_level.level_name

		upgrade_price = upgrade_level.price

		# prefer this to a tooltip so that we can control its appearance
		# by mouse enter/exit events rather than by the mouse being idle
		name_text.text = upgrade_level.level_name
		price_text.text = "Price: " + str(upgrade_level.price)
		description_text.text = upgrade_level.level_description

		disabled = false
		enable_button(true)
	else:
		text = "-"
		description_text.text = "-"

		disabled = true
		disable_button(true)

	tooltip.hide()

func enable_button(set_cursor: bool):
	if set_cursor:
		mouse_default_cursor_shape = CURSOR_POINTING_HAND

	set_process(true)

func disable_button(set_cursor: bool):
	if set_cursor:
		mouse_default_cursor_shape = CURSOR_ARROW

	set_process(false)

func update_affordability(money: int):
	if upgrade_price > money:
		disabled = true
		disable_button(false)
	else:
		disabled = false
		enable_button(false)

func upgrade():
	tooltip.hide()
	upgrade_tower.emit(upgrade_index)

func _process(_delta):
	if Engine.is_editor_hint():
		return

	if Input.is_action_just_pressed(action_name):
		print("Upgrading tower via shortcut")
		upgrade()

func _on_pressed():
	print("Upgrading tower via button")
	upgrade()

func _on_mouse_entered():
	if upgrade_level:
		tooltip.show()

func _on_mouse_exited():
	tooltip.hide()
