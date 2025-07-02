@tool
class_name UpgradeTowerButtonAppearance
extends Node

@export
var button: UpgradeTowerButton

@export
var tooltip: Control

@export
var tooltip_background: Control

@export
var name_text: Label

@export
var price_text: Label

@export
var description_text: Label

func _ready() -> void:
	tooltip_background.resized.connect(_on_tooltip_background_resized)

func show_tooltip() -> void:
	tooltip.show()

func hide_tooltip() -> void:
	tooltip.hide()

func realign_tooltip() -> void:
	# background node is a panel container, so shrinks to the
	# correct size after the tooltip content gets updated
	tooltip.size.y = tooltip.get_node("Background").size.y

	if button.align_tooltip_bottom:
		tooltip.position.y = button.size.y - tooltip.size.y
	else:
		tooltip.position.y = 0

func set_upgrade_level(upgrade_level: TowerLevel) -> void:
	if upgrade_level:
		button.text = upgrade_level.level_name

		name_text.text = upgrade_level.level_name
		price_text.text = "Price: " + str(upgrade_level.price)
		description_text.text = upgrade_level.level_description
	else:
		button.text = "-"

		description_text.text = "-"

	realign_tooltip()
	hide_tooltip()

func _on_tooltip_background_resized() -> void:
	realign_tooltip()
