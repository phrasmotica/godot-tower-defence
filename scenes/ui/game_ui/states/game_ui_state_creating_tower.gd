class_name GameUIStateCreatingTower
extends GameUIState

func _enter_tree() -> void:
	Logger.info("Game UI is now creating tower")

	var tower_scene := _state_data.get_tower_scene()

	var placing_tower: Tower = tower_scene.instantiate()

	if not BankManager.can_afford(placing_tower.price):
		Logger.error("%s purchase failed: cannot afford" % placing_tower.name)

		transition_state(GameUI.State.ENABLED)

	Logger.debug("Purchasing %s" % placing_tower.name)

	placing_tower.hide()

	transition_state(GameUI.State.PLACING_TOWER, GameUIStateData.build().with_placing_tower(placing_tower))
