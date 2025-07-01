class_name CreateTowerButtonStateDisabled
extends CreateTowerButtonState

func _enter_tree() -> void:
	print("CreateTowerButton is now disabled")

	_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

	GameEvents.game_started.connect(_on_game_started)

func _on_game_started(_path_index: int) -> void:
	transition_state(CreateTowerButton.State.ENABLED)
