class_name GameUIStateEnabled
extends GameUIState

func _enter_tree() -> void:
	print("Game UI is now enabled")

	_create_tower_ui.create_tower.connect(_on_create_tower)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		TowerEvents.emit_deselect_tower()

	if Input.is_action_just_pressed("next_tower"):
		TowerEvents.emit_next_tower()

	if Input.is_action_just_pressed("previous_tower"):
		TowerEvents.emit_previous_tower()

func _on_create_tower(tower_scene: PackedScene) -> void:
	transition_state(GameUI.State.CREATING_TOWER, GameUIStateData.build().with_tower_scene(tower_scene))
