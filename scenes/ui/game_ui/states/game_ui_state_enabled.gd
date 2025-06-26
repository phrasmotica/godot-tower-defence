class_name GameUIStateEnabled
extends GameUIState

func _enter_tree() -> void:
	print("Game UI is now enabled")

	TowerEvents.tower_created.connect(_on_tower_created)
	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)
	TowerEvents.tower_sold.connect(_on_tower_sold)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		TowerEvents.emit_tower_deselected()

	if Input.is_action_just_pressed("next_tower"):
		TowerEvents.emit_next_tower()

	if Input.is_action_just_pressed("previous_tower"):
		TowerEvents.emit_previous_tower()

func _on_tower_created(tower_scene: PackedScene) -> void:
	transition_state(GameUI.State.CREATING_TOWER, GameUIStateData.build().with_tower_scene(tower_scene))

func _on_selected_tower_changed(_tower: Tower, old_tower: Tower) -> void:
	if old_tower == null:
		_appearance.animate_show_ui()

func _on_tower_deselected() -> void:
	_appearance.animate_hide_ui()

func _on_tower_sold() -> void:
	_appearance.animate_hide_ui()
