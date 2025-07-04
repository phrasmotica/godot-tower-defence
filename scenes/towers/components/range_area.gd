@tool
class_name RangeArea extends Node2D

@export_range(1.0, 10.0)
var radius := 3.0:
	set(value):
		radius = value

		_refresh()

@onready
var range_sprite: AnimatedSprite2D = %Sprite2D

func _ready() -> void:
	_refresh()

# TODO: update the current time in the sprite's shader material

func _refresh() -> void:
	if range_sprite:
		var range_scale := radius / 10
		range_sprite.scale = range_scale * Vector2.ONE

func set_default_look():
	range_sprite.modulate = Color.WHITE

func set_error_look():
	range_sprite.modulate = Color.RED
