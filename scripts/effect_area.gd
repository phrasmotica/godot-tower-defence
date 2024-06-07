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
		collision_area.visible = value
		collision_area.monitorable = value
		collision_area.monitoring = value

@export_range(1.0, 10.0)
var radius := 3.0:
	set(value):
		radius = value
		adjust_range(value)

func _ready():
	circle_shape = collision_shape.shape as CircleShape2D
	if not circle_shape:
		push_error("EffectArea collision shape is not a CircleShape2D!")
		return

	adjust_range(radius)

func adjust_range(projectile_range: float):
	if circle_shape:
		circle_shape.radius = 100 * projectile_range
