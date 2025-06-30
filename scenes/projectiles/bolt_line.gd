@tool
class_name BoltLine extends Node2D

@export_range(1.0, 10.0)
var shooting_range := 3.0:
	set(value):
		shooting_range = value

		_refresh()

@onready
var line: Line2D = %Line2D

@onready
var animation_player: AnimationPlayer = %AnimationPlayer

func fire() -> void:
	animation_player.play("fire")

func _refresh() -> void:
	line.points[1].x = 100 * shooting_range
