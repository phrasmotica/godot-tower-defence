@tool
class_name BoltLine extends Node2D

@onready
var line: Line2D = $Line2D

@export_range(1.0, 10.0)
var shooting_range := 3.0:
	set(value):
		shooting_range = value

		line.points[1].x = 100 * value
