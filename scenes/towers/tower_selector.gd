class_name TowerSelector

var _lister: TowerLister = null

var _selected_idx := 0
var _selected_tower: Tower = null

func _init(lister: TowerLister) -> void:
	_lister = lister

func get_selected_index() -> int:
	return _selected_idx

func get_current() -> Tower:
	return _selected_tower

func set_current(tower: Tower) -> void:
	_selected_tower = tower
	_selected_idx = _lister.index_of(tower)

func reset_current() -> void:
	_selected_tower = null
	_selected_idx = -1

func next_tower() -> Tower:
	var all_towers := _lister.list()

	if all_towers.size() <= 0:
		return null

	if all_towers.size() == 1 and _selected_tower:
		return _selected_tower

	Logger.debug("Selecting next tower")

	var selected_index := _selected_idx

	if _selected_tower:
		selected_index = (selected_index + 1) % all_towers.size()

	return all_towers[selected_index]

func previous_tower() -> Tower:
	var all_towers := _lister.list()

	if all_towers.size() <= 0:
		return null

	if all_towers.size() == 1 and _selected_tower:
		return _selected_tower

	Logger.debug("Selecting previous tower")

	var selected_index := _selected_idx

	if _selected_tower:
		selected_index = (selected_index - 1) % all_towers.size()

	return all_towers[selected_index]
