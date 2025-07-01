class_name UpgradeTowerButtonStateData

var _set_cursor := false

static func build() -> UpgradeTowerButtonStateData:
	return UpgradeTowerButtonStateData.new()

func with_set_cursor(set_cursor: bool) -> UpgradeTowerButtonStateData:
	_set_cursor = set_cursor
	return self

func get_set_cursor() -> bool:
	return _set_cursor
