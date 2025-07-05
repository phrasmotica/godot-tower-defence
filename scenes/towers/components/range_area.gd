@tool
class_name RangeArea extends Node2D

@export_range(1.0, 10.0)
var radius := 3.0:
	set(value):
		radius = value

		_refresh()

@export_group("Shader Parameters")

@export
var animate_shader := false:
	set(value):
		animate_shader = value

		_refresh()

@export_range(0.1, 10.0)
var time_period := 5.0:
	set(value):
		time_period = value

		if Engine.is_editor_hint():
			_shader_updater.update_time_period(time_period)

@onready
var range_sprite: AnimatedSprite2D = %Sprite2D

var _shader_updater: ShaderTimeUpdater = null
var _current_time := 0.0

func _ready() -> void:
	assert(range_sprite)

	var range_material := range_sprite.material as ShaderMaterial
	assert(range_material)

	_shader_updater = ShaderTimeUpdater.new(range_material)
	_shader_updater.update_time_period(time_period)

func _process(delta: float) -> void:
	if animate_shader:
		_current_time += delta / time_period

		if _current_time > 1.0:
			_current_time = 0.0

		_shader_updater.update_current_time(_current_time)

func _refresh() -> void:
	var range_scale := radius / 10.0
	range_sprite.scale = range_scale * Vector2.ONE

	if not animate_shader:
		_current_time = 0.0

		_shader_updater.update_current_time(_current_time)

	_shader_updater.set_bool("show_scan_line", animate_shader)

func set_default_look() -> void:
	range_sprite.modulate = Color.WHITE

func set_error_look() -> void:
	range_sprite.modulate = Color.RED
