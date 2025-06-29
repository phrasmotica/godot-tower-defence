@tool
class_name TowerProgressBar extends Node2D

@onready
var rectangle: Sprite2D = %Sprite2D

@onready
var animation_player: AnimationPlayer = $AnimationPlayer

@export
var colour: Color = Color.BLUE:
	set(value):
		colour = value

		_refresh()

signal started
signal finished

func _ready() -> void:
	_refresh()

	if not Engine.is_editor_hint():
		rectangle.hide()

func _refresh() -> void:
	if rectangle:
		var gradient := Gradient.new()
		gradient.colors = [colour]

		assert(rectangle.texture is GradientTexture2D)
		(rectangle.texture as GradientTexture2D).gradient = gradient

func animate() -> void:
	started.emit()

	animation_player.play("progress")

func finish() -> void:
	finished.emit()
