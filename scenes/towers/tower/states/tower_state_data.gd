class_name TowerStateData

var _upgrade_index: int

static func build() -> TowerStateData:
	return TowerStateData.new()

func with_upgrade_index(upgrade_index: int) -> TowerStateData:
	_upgrade_index = upgrade_index
	return self

func get_upgrade_index() -> int:
	return _upgrade_index
