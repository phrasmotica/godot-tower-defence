class_name EnemyInfo

var _name := ""
var _bounty := 0

func _init(name: String, bounty: int) -> void:
	_name = name
	_bounty = bounty

func get_name() -> String:
	return _name

func get_bounty() -> int:
	return _bounty
