class_name UpgradeTowerButtonStateData

var _upgrade_level: TowerLevel = null

static func build() -> UpgradeTowerButtonStateData:
	return UpgradeTowerButtonStateData.new()

func with_upgrade_level(upgrade_level: TowerLevel) -> UpgradeTowerButtonStateData:
	_upgrade_level = upgrade_level
	return self

func get_upgrade_level() -> TowerLevel:
	return _upgrade_level
