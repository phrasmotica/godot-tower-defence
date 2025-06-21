class_name GameUIStateEnabled
extends GameUIState

func _enter_tree() -> void:
	print("Game UI is now enabled")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if _game_ui.placing_tower:
			_game_ui.stop_tower_creation(true)

			_create_tower_ui.set_default_mode()
		else:
			_game_ui.emit_deselect_tower()

	if Input.is_action_just_pressed("next_tower"):
		_game_ui.emit_next_tower()

	if Input.is_action_just_pressed("previous_tower"):
		_game_ui.emit_previous_tower()
