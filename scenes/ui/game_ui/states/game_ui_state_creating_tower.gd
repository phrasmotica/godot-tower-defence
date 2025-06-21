class_name GameUIStateCreatingTower
extends GameUIState

func _enter_tree() -> void:
	print("Game UI is now creating tower")

	var tower_scene := _state_data.get_tower_scene()

	_create_tower_ui.set_default_mode_except(tower_scene)

	var placing_tower: Tower = tower_scene.instantiate()

	if not BankManager.can_afford(placing_tower.price):
		print(placing_tower.name + " purchase failed: cannot afford")

		transition_state(GameUI.State.ENABLED)

	print("Purchasing " + placing_tower.name)

	placing_tower.path_manager = _path_manager
	placing_tower.hide()

	_game_ui.add_child(placing_tower)

	transition_state(GameUI.State.PLACING_TOWER, GameUIStateData.build().with_placing_tower(placing_tower))
