class_name TowerSelector

var _selected_idx := 0
var _selected_tower: Tower = null

func next_tower(all_towers: Array[Tower]) -> Tower:
	if all_towers.size() <= 0:
		return null

	if all_towers.size() == 1 and _selected_tower:
		return _selected_tower

	print("Selecting next tower")

	if _selected_tower:
		_selected_idx = (_selected_idx + 1) % all_towers.size()

	_selected_tower = all_towers[_selected_idx]

	return _selected_tower

func previous_tower(all_towers: Array[Tower]) -> Tower:
	if all_towers.size() <= 0:
		return null

	if all_towers.size() == 1 and _selected_tower:
		return _selected_tower

	print("Selecting previous tower")

	if _selected_tower:
		_selected_idx = (_selected_idx - 1) % all_towers.size()

	_selected_tower = all_towers[_selected_idx]

	return _selected_tower
