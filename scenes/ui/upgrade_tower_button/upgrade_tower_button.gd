@tool
class_name UpgradeTowerButton extends Button

enum State { DISABLED, CANNOT_AFFORD, ENABLED, UPGRADING }

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

@export
var align_tooltip_bottom := false:
	set(value):
		align_tooltip_bottom = value

		_refresh()

var upgrade_level: TowerLevel

signal upgrade_tower(index: int)

func set_upgrade_level(tower: Tower):
	upgrade_level = tower.get_upgrade(upgrade_index) if tower else null

	if upgrade_level:
		text = upgrade_level.level_name

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

	_refresh()

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
	if upgrade_level:
		if upgrade_level.price <= money:
			disabled = false
			enable_button(false)
		else:
			disabled = true
			disable_button(false)
	else:
		disabled = true
		disable_button(true)

func _refresh() -> void:
	if align_tooltip_bottom:
		tooltip.position.y = self.size.y - tooltip.size.y
	else:
		tooltip.position.y = 0

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

func _on_background_resized():
	# background node is a panel container, so shrinks to the
	# correct size after the tooltip content gets updated
	tooltip.size.y = tooltip.get_node("Background").size.y
	_refresh()
