class_name TowerSelector

var _selected_idx := 0
var _selected_tower: Tower = null

func get_selected_index() -> int:
	return _selected_idx

func get_current() -> Tower:
	return _selected_tower

func set_current(tower: Tower, index: int) -> void:
	_selected_tower = tower
	_selected_idx = index

func reset_current() -> void:
	_selected_tower = null
	_selected_idx = -1

func next_tower(all_towers: Array[Tower]) -> Tower:
	if all_towers.size() <= 0:
		return null

	if all_towers.size() == 1 and _selected_tower:
		return _selected_tower

	print("Selecting next tower")

	var selected_index := _selected_idx

	if _selected_tower:
		selected_index = (selected_index + 1) % all_towers.size()

	return all_towers[selected_index]

func previous_tower(all_towers: Array[Tower]) -> Tower:
	if all_towers.size() <= 0:
		return null

	if all_towers.size() == 1 and _selected_tower:
		return _selected_tower

	print("Selecting previous tower")

	var selected_index := _selected_idx

	if _selected_tower:
		selected_index = (selected_index - 1) % all_towers.size()

	return all_towers[selected_index]
