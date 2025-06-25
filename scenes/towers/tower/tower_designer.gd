@tool
class_name TowerDesigner
extends Node

@export
var levels: Array[TowerLevel]

signal adjust_range(range: float)
signal adjust_effect_range(range: float)

func _ready() -> void:
	if Engine.is_editor_hint():
		for level in levels:
			level.adjust_range.connect(adjust_range.emit)
			level.adjust_effect_range.connect(adjust_effect_range.emit)
