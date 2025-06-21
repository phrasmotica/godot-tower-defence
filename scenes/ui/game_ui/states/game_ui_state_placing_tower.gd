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

	_game_ui.emit_tower_placing(placing_tower)

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
	placing_tower.is_valid_location = is_valid

	if is_valid:
		placing_tower.show_visualiser()
		placing_tower.set_default_look()
	else:
		placing_tower.hide_visualiser()
		placing_tower.set_error_look()

func _on_path_manager_valid_area_clicked() -> void:
	placing_tower.try_place()

func _on_placing_tower_placed(tower: Tower) -> void:
	print("Placed new tower")

	# TODO: these callbacks need to exist outside of this state's lifetime
	placing_tower.on_selected.connect(_on_placing_tower_selected)
	placing_tower.on_upgrade_finish.connect(_on_placing_tower_on_upgrade_finish)

	_game_ui.emit_tower_placed(tower)

	BankManager.deduct(tower.price)

	finish()

func _on_placing_tower_selected(tower: Tower) -> void:
	print("Selected " + tower.name)

	_game_ui.emit_tower_selected(tower)

func _on_placing_tower_on_upgrade_finish(tower: Tower, _next_level: TowerLevel) -> void:
	print("Selected tower upgrade finished")

	_tower_ui.set_tower(tower)

	# allows tower upgrade buttons to update their state
	BankManager.emit_money_changed()
