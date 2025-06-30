@tool
class_name TowerVisualiser
extends Node2D

@export
var show_range_area := true:
	set(value):
		show_range_area = value

		_refresh()

@export
var show_bolt_line := false:
	set(value):
		show_bolt_line = value

		_refresh()

@export
var radius := 3.0:
	set(value):
		radius = value

		_refresh()

@onready
var range_area: RangeArea = %RangeArea

@onready
var bolt_line: BoltLine = %BoltLine

func _refresh() -> void:
	if bolt_line:
		bolt_line.visible = show_bolt_line
		bolt_line.shooting_range = radius

	if range_area:
		range_area.visible = show_range_area
		range_area.radius = radius

func set_default_look() -> void:
	range_area.set_default_look()

func set_error_look() -> void:
	range_area.set_error_look()

func show_range() -> void:
	range_area.show()

func hide_range() -> void:
	range_area.hide()
