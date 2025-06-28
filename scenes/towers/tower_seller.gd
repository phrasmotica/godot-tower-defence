class_name TowerSeller

var _selector: TowerSelector = null

func _init(selector: TowerSelector) -> void:
	_selector = selector

func try_sell() -> int:
	var selected_tower := _selector.get_current()

	if not selected_tower:
		print("Tower sell failed: no tower selected")
		return -1

	print("Selling tower")

	selected_tower.deselect()
	selected_tower.sell()

	var index := _selector.get_selected_index()

	_selector.reset_current()

	return index
