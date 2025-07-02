class_name TowerUpgrader

var _selector: TowerSelector = null

func _init(selector: TowerSelector) -> void:
	_selector = selector

func try_upgrade(index: int) -> void:
	var selected_tower := _selector.get_current()

	if not selected_tower:
		Logger.info("Tower upgrade failed: no tower selected")
		return

	var next_level = selected_tower.get_upgrade(index)
	if not next_level:
		Logger.info("Tower upgrade failed: no more upgrades")
		return

	if selected_tower.is_upgrading():
		Logger.info("Tower upgrade failed: already upgrading")
		return

	if not BankManager.can_afford(next_level.price):
		Logger.info("Tower upgrade failed: cannot afford")
		return

	Logger.info("Upgrading tower")

	selected_tower.upgrade(index)

	BankManager.deduct(next_level.price)

	TowerEvents.emit_tower_upgrade_started(index, selected_tower, next_level)
