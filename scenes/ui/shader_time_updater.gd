class_name ShaderTimeUpdater

var _material: ShaderMaterial = null

func _init(material: ShaderMaterial) -> void:
	_material = material

func update_time_period(time_period: float) -> void:
	_material.set_shader_parameter("time_period", time_period)

func update_current_time(current_time: float) -> void:
	_material.set_shader_parameter("current_time", current_time)

func set_bool(param: StringName, value: bool) -> void:
	_material.set_shader_parameter(param, value)
