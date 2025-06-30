@tool
class_name TowerDesigner
extends Node

@export
var weaponry: TowerWeaponry

signal adjust_sprite(sprite: Texture2D)
signal adjust_range(range: float)
signal adjust_effect_range(range: float)

func _ready() -> void:
	if Engine.is_editor_hint():
		for level in weaponry.get_all_levels():
			level.adjust_sprite.connect(adjust_sprite.emit)
			level.adjust_range.connect(adjust_range.emit)
			level.adjust_effect_range.connect(adjust_effect_range.emit)
