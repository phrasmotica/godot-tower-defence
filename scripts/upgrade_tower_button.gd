class_name UpgradeTowerButton extends Button

@export var action_name: StringName
@export var upgrade_index := 0

@onready var description = $TowerDescription
@onready var description_text = $TowerDescription/Label

var upgrade_level: TowerLevel

signal upgrade_tower(index: int)

func set_upgrade_level(tower: Tower):
	upgrade_level = tower.get_upgrade(upgrade_index)

	if upgrade_level:
		show()

		# prefer this to a tooltip so that we can control its appearance
		# by mouse enter/exit events rather than by the mouse being idle
		description_text.text = upgrade_level.level_description
	else:
		hide()

	description.hide()

func enable_button():
	set_process(true)

func disable_button():
	set_process(false)

func upgrade():
	description.hide()
	upgrade_tower.emit(upgrade_index)

func _process(_delta):
	if Input.is_action_just_pressed(action_name):
		print("Upgrading tower via shortcut")
		upgrade()

func _on_pressed():
	print("Upgrading tower via button")
	upgrade()

func _on_mouse_entered():
	if not disabled:
		# TODO: might want to see the info even if we can't afford it?
		description.show()

func _on_mouse_exited():
	description.hide()
