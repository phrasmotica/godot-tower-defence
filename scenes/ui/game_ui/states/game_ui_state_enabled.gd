class_name GameUIStateEnabled
extends GameUIState

func _enter_tree() -> void:
	print("Game UI is now enabled")

	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)
	TowerEvents.tower_sold.connect(_on_tower_sold)

	_create_tower_ui.create_tower.connect(_on_create_tower)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		TowerEvents.emit_tower_deselected()

	if Input.is_action_just_pressed("next_tower"):
		TowerEvents.emit_next_tower()

	if Input.is_action_just_pressed("previous_tower"):
		TowerEvents.emit_previous_tower()

func _on_selected_tower_changed(_tower: Tower, old_tower: Tower) -> void:
	# we assume tower is not null here
	# tower.reparent(_game_ui, true)

	if old_tower == null:
		_appearance.animate_show_ui()

func _on_tower_deselected() -> void:
	_appearance.animate_hide_ui()

func _on_tower_sold() -> void:
	_appearance.animate_hide_ui()

func _on_create_tower(tower_scene: PackedScene) -> void:
	transition_state(GameUI.State.CREATING_TOWER, GameUIStateData.build().with_tower_scene(tower_scene))
