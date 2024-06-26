@tool
class_name BoltLine extends Node2D

@export
var line: Line2D

@export
var animation_player: AnimationPlayer

@export_range(1.0, 10.0)
var shooting_range := 3.0:
	set(value):
		shooting_range = value

		line.points[1].x = 100 * value

func fire():
	animation_player.play("fire")
