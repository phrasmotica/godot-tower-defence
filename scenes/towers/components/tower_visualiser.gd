@tool
class_name TowerVisualiser extends Node2D

@export
var range_area: RangeArea

@export
var bolt_line: BoltLine

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

func _refresh() -> void:
	bolt_line.visible = show_bolt_line
	bolt_line.shooting_range = radius

	range_area.visible = show_range_area
	range_area.radius = radius

func set_default_look():
	range_area.set_default_look()

func set_error_look():
	range_area.set_error_look()

func show_range():
	range_area.show()

func hide_range():
	range_area.hide()

func _on_levels_adjust_effect_range(effect_range: float):
	radius = effect_range

func _on_levels_adjust_range(projectile_range: float):
	radius = projectile_range
