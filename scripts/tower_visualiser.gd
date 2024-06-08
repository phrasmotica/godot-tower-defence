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
		range_area.visible = value

@export
var show_bolt_line := false:
	set(value):
		show_bolt_line = value
		bolt_line.visible = value

func set_default_look():
	range_area.set_default_look()

func set_error_look():
	range_area.set_error_look()

func show_range():
	range_area.show()

func hide_range():
	range_area.hide()

func adjust_range(projectile_range: float):
	range_area.radius = projectile_range
	bolt_line.shooting_range = projectile_range

func _on_levels_adjust_effect_range(effect_range: float):
	adjust_range(effect_range)

func _on_levels_adjust_range(projectile_range: float):
	adjust_range(projectile_range)
