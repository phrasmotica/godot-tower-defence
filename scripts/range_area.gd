@tool
class_name RangeArea extends Node2D

@onready var range_sprite: AnimatedSprite2D = $RangeSprite

@export_range(1, 10)
var radius := 3:
	set(value):
		radius = value
		adjust_range(value)

func _ready():
	adjust_range(radius)

func adjust_range(projectile_range: int):
	var range_scale := float(projectile_range) / 10
	range_sprite.scale = Vector2(range_scale, range_scale)

func set_default_look():
	range_sprite.modulate = Color.WHITE

func set_error_look():
	range_sprite.modulate = Color.RED
