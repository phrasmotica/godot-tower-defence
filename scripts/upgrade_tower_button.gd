@tool
class_name UpgradeTowerButton extends Button

@export var action_name: StringName
@export var upgrade_index := 0

@export
var description: Control

@export
var description_text: Label

@export
var show_description := false:
	set(value):
		description.visible = value

	get:
		return description.visible

var upgrade_level: TowerLevel
var upgrade_price := 0

signal upgrade_tower(index: int)

func set_upgrade_level(tower: Tower):
	upgrade_level = tower.get_upgrade(upgrade_index)

	if upgrade_level:
		disabled = false

		text = upgrade_level.level_name
		upgrade_price = upgrade_level.price

		# prefer this to a tooltip so that we can control its appearance
		# by mouse enter/exit events rather than by the mouse being idle
		description_text.text = upgrade_level.level_description
	else:
		text = "-"
		disabled = true

	description.hide()

func enable_button():
	set_process(true)

func disable_button():
	set_process(false)

func update_affordability(money: int):
	if upgrade_price > money:
		disabled = true
		disable_button()
	else:
		disabled = false
		enable_button()

func upgrade():
	description.hide()
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
	description.show()

func _on_mouse_exited():
	description.hide()
