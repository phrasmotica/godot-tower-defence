class_name TowerLevelManager

var _base_level: TowerLevel = null
var _upgrade_path: Array[int] = []
var _ongoing_upgrade_index := -1

func _init(base_level: TowerLevel) -> void:
	_base_level = base_level

func start_upgrade(index: int) -> TowerLevel:
	var next_level := get_upgrade(index)

	if next_level:
		_ongoing_upgrade_index = index

	return next_level

func finish_upgrade() -> TowerLevel:
	if _ongoing_upgrade_index < 0 or not get_upgrade(_ongoing_upgrade_index):
		return

	_upgrade_path.append(_ongoing_upgrade_index)
	_ongoing_upgrade_index = -1

	return get_current_level()

func get_upgrade(index: int) -> TowerLevel:
	return _base_level.get_upgrade(_upgrade_path, index)

func get_current_level() -> TowerLevel:
	return _base_level.get_current_level(_upgrade_path)

func get_all_levels() -> Array[TowerLevel]:
	return _base_level.get_all_levels()

func get_total_value() -> int:
	return _base_level.get_total_value(_upgrade_path)
