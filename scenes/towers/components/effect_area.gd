@tool
class_name EffectArea extends Node2D

@export
var collision_area: Area2D

@export
var collision_shape: CollisionShape2D

var circle_shape: CircleShape2D

@export
var enabled := true:
	set(value):
		enabled = value

		_refresh()

@export_range(1.0, 10.0)
var radius := 3.0:
	set(value):
		radius = value

		_refresh()

func _ready() -> void:
	circle_shape = collision_shape.shape as CircleShape2D
	if not circle_shape:
		push_error("EffectArea collision shape is not a CircleShape2D!")
		return

	_refresh()

func _refresh() -> void:
	collision_area.visible = enabled
	collision_area.monitorable = enabled
	collision_area.monitoring = enabled

	if circle_shape:
		circle_shape.radius = 100 * radius
