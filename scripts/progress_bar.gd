@tool
class_name TowerProgressBar extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export
var color_rect: ColorRect

@export
var colour: Color = Color.BLUE:
	set(value):
		color_rect.color = value

	get:
		return color_rect.color

signal started
signal finished

func _ready():
	# TODO: do this when tower is put into placing mode instead
	if not Engine.is_editor_hint():
		color_rect.hide()

func animate():
	started.emit()

	animation_player.play("progress")

func finish():
	finished.emit()
