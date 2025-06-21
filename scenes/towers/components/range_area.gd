@tool
class_name RangeArea extends Node2D

@export
var range_sprite: AnimatedSprite2D

@export_range(1.0, 10.0)
var radius := 3.0:
	set(value):
		radius = value

		_refresh()

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if range_sprite:
		var range_scale := radius / 10
		range_sprite.scale = range_scale * Vector2.ONE

func set_default_look():
	range_sprite.modulate = Color.WHITE

func set_error_look():
	range_sprite.modulate = Color.RED
