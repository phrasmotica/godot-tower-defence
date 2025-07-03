class_name GameUIStateDisabled
extends GameUIState

func _enter_tree() -> void:
	Logger.info("Game UI is now disabled")

	GameEvents.game_started.connect(_on_game_events_game_started)

func _on_game_events_game_started(_path_index: int) -> void:
	transition_state(GameUI.State.ENABLED)
