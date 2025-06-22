class_name GameUIStatePlacingTower
extends GameUIState

var placing_tower: Tower

func _enter_tree() -> void:
	print("Game UI is now placing tower")

	placing_tower = _state_data.get_placing_tower()
	if not placing_tower:
		print("No tower to place!")

		transition_state(GameUI.State.ENABLED)

	_appearance.cancel_tower.connect(_on_cancel_tower)

	TowerEvents.tower_placing_finished.connect(_on_tower_placing_finished)

	TowerEvents.emit_tower_placing_started(placing_tower)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		cancel()

func _on_cancel_tower() -> void:
	cancel()

func cancel() -> void:
	placing_tower.queue_free()
	placing_tower = null

	finish()

func finish() -> void:
	_appearance.default_mode()

	transition_state(GameUI.State.ENABLED)

func _on_tower_placing_finished(_tower: Tower) -> void:
	finish()
