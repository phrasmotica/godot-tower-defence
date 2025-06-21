class_name GameUIStateEnabled
extends GameUIState

func _enter_tree() -> void:
	print("Game UI is now enabled")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		TowerEvents.emit_deselect_tower()

	if Input.is_action_just_pressed("next_tower"):
		TowerEvents.emit_next_tower()

	if Input.is_action_just_pressed("previous_tower"):
		TowerEvents.emit_previous_tower()
