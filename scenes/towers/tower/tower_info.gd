class_name TowerInfo

var _name := ""
var _price := 0

func _init(name: String, price: int) -> void:
	_name = name
	_price = price

func get_name() -> String:
	return _name

func get_price() -> int:
	return _price
