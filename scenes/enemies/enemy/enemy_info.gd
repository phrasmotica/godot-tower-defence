class_name EnemyInfo

var _name := ""

func _init(name: String) -> void:
	_name = name

func get_name() -> String:
	return _name
