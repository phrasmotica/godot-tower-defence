class_name TowerLister

var _all_towers: Array[Tower] = []

func list() -> Array[Tower]:
	return _all_towers

func index_of(tower: Tower) -> int:
	return _all_towers.find(tower)

func append(tower: Tower) -> void:
	_all_towers.append(tower)

func drop_at(index: int) -> void:
	_all_towers.remove_at(index)
