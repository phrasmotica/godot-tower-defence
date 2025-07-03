class_name TowerSeller

var _lister: TowerLister = null
var _selector: TowerSelector = null

func _init(lister: TowerLister, selector: TowerSelector) -> void:
	_lister = lister
	_selector = selector

func try_sell() -> void:
	var selected_tower := _selector.get_current()

	if not selected_tower:
		Logger.info("Tower sell failed: no tower selected")
		return

	Logger.info("Selling tower")

	selected_tower.deselect()
	selected_tower.sell()

	var sold_index := _selector.get_selected_index()

	_selector.reset_current()

	if sold_index >= 0:
		_lister.drop_at(sold_index)
