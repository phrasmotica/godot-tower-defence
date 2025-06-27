class_name TowerUpgrader

func try_upgrade(tower: Tower, index: int) -> void:
	var next_level = tower.get_upgrade(index)
	if not next_level:
		print("Tower upgrade failed: no more upgrades")
		return

	if tower.is_upgrading():
		print("Tower upgrade failed: already upgrading")
		return

	if not BankManager.can_afford(next_level.price):
		print("Tower upgrade failed: cannot afford")
		return

	print("Upgrading tower")

	tower.upgrade(index)

	BankManager.deduct(next_level.price)

	TowerEvents.emit_tower_upgrade_started(tower, next_level)
