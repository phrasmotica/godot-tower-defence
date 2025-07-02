class_name GameUIStatePlacingTower
extends GameUIState

var _placing_tower: Tower

func _enter_tree() -> void:
	Logger.info("Game UI is now placing tower")

	_placing_tower = _state_data.get_placing_tower()
	if not _placing_tower:
		Logger.info("No tower to place!")

		transition_state(GameUI.State.ENABLED)

	TowerEvents.tower_created.connect(_on_tower_created)

	TowerEvents.tower_placing_cancelled.connect(_on_tower_placing_cancelled)
	TowerEvents.tower_placing_finished.connect(_on_tower_placing_finished)

	_game_ui.add_child(_placing_tower)

	TowerEvents.emit_tower_placing_started(_placing_tower)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		TowerEvents.emit_tower_placing_cancelled()

func _on_tower_created(tower_scene: PackedScene) -> void:
	cancel()
	transition_state(GameUI.State.CREATING_TOWER, GameUIStateData.build().with_tower_scene(tower_scene))

func _on_tower_placing_cancelled() -> void:
	cancel()
	finish()

func _on_tower_placing_finished(_tower: Tower) -> void:
	finish()

func cancel() -> void:
	_placing_tower.queue_free()
	_placing_tower = null

func finish() -> void:
	transition_state(GameUI.State.ENABLED)
