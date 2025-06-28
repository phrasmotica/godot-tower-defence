@tool
class_name Explosion
extends Node2D

@export_range(0.1, 1.0)
var time_period := 1.0:
	set(value):
		time_period = value

		if Engine.is_editor_hint():
			_shader_updater.update_time_period(time_period)

@onready
var sprite: AnimatedSprite2D = %Sprite

var _shader_updater: ShaderTimeUpdater = null
var _current_time := 0.0

func _ready() -> void:
	var explosion_material := sprite.material as ShaderMaterial
	assert(explosion_material)

	_shader_updater = ShaderTimeUpdater.new(explosion_material)
	_shader_updater.update_time_period(time_period)

func _process(delta: float) -> void:
	_current_time += delta

	if _current_time > time_period:
		_current_time = 0

		if not Engine.is_editor_hint():
			queue_free()

	_shader_updater.update_current_time(_current_time)
