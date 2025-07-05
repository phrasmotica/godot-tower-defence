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

@export
var scan_duration := 5.0:
	set(value):
		scan_duration = value

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
		range_area.time_period = scan_duration

		# TODO: the trail size in the range area shader should vary
		# with the time period. Smaller time period, larger trail size...

func set_default_look() -> void:
	range_area.set_default_look()

func set_error_look() -> void:
	range_area.set_error_look()

func show_range() -> void:
	range_area.show()

func hide_range() -> void:
	range_area.hide()

func animate_range(animate: bool) -> void:
	range_area.animate_shader = animate
