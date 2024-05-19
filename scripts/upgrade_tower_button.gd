class_name UpgradeTowerButton extends Button

@export var action_name: StringName

@onready var description = $TowerDescription
@onready var description_text = $TowerDescription/Label

var upgrade_level: TowerLevel

signal upgrade_tower(level: TowerLevel)

func set_upgrade_level(level: TowerLevel):
	upgrade_level = level

	if upgrade_level:
		disabled = false

		# prefer this to a tooltip so that we can control its appearance
		# by mouse enter/exit events rather than by the mouse being idle
		description_text.text = upgrade_level.level_description
	else:
		disabled = true

	description.hide()

func upgrade():
	description.hide()
	upgrade_tower.emit(upgrade_level)

func _process(_delta):
	if Input.is_action_just_pressed(action_name):
		print("Upgrading tower via shortcut")
		upgrade()

func _on_pressed():
	print("Upgrading tower via button")
	upgrade()

func _on_mouse_entered():
	if not disabled:
		description.show()

func _on_mouse_exited():
	description.hide()
