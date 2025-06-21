class_name GameUIStatePlacingTower
extends GameUIState

var placing_tower: Tower

func _enter_tree() -> void:
	print("Game UI is now placing tower")

	placing_tower = _state_data.get_placing_tower()
	if not placing_tower:
		print("No tower to place!")

		transition_state(GameUI.State.ENABLED)

	placing_tower.on_placed.connect(_on_placing_tower_placed)

	TowerEvents.emit_tower_placing_started(placing_tower)

	_create_tower_ui.cancel_tower.connect(_on_create_tower_ui_cancel_tower)

	_path_manager.mouse_validity_changed.connect(_on_path_manager_mouse_validity_changed)
	_path_manager.valid_area_clicked.connect(_on_path_manager_valid_area_clicked)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		cancel()

func _on_create_tower_ui_cancel_tower() -> void:
	cancel()

func cancel() -> void:
	placing_tower.queue_free()
	placing_tower = null

	finish()

func finish() -> void:
	_create_tower_ui.set_default_mode()

	transition_state(GameUI.State.ENABLED)

func _on_path_manager_mouse_validity_changed(is_valid: bool) -> void:
	TowerPlacingEvents.emit_mouse_over_path_area_changed(is_valid)

func _on_path_manager_valid_area_clicked() -> void:
	placing_tower.try_place()

func _on_placing_tower_placed(tower: Tower) -> void:
	print("Placed new tower")

	placing_tower.on_selected.connect(TowerEvents.emit_tower_selected)
	placing_tower.on_upgrade_finish.connect(TowerEvents.emit_tower_upgrade_finished)

	TowerEvents.emit_tower_placing_finished(tower)

	BankManager.deduct(tower.price)

	finish()
