@tool
class_name RangeArea extends Node2D

@export
var range_sprite: AnimatedSprite2D

@export_range(1.0, 10.0)
var radius := 3.0:
	set(value):
		radius = value
		adjust_range(value)

func _ready():
	adjust_range(radius)

func adjust_range(projectile_range: float):
	if range_sprite:
		var range_scale := projectile_range / 10
		range_sprite.scale = Vector2(range_scale, range_scale)

func set_default_look():
	range_sprite.modulate = Color.WHITE

func set_error_look():
	range_sprite.modulate = Color.RED
