class_name TowerStateFiring
extends TowerState

func _enter_tree() -> void:
	print("Tower is now firing")

	_selection.mouse_filter = Control.MOUSE_FILTER_STOP

	_selection.mouse_entered.connect(_on_selection_mouse_entered)
	_selection.mouse_exited.connect(_on_selection_mouse_exited)
	_selection.gui_input.connect(_on_selection_gui_input)

func _process(delta: float) -> void:
	_tower.scan(delta)

func _on_selection_mouse_entered() -> void:
	_visualiser.show()

func _on_selection_mouse_exited() -> void:
	if not _tower.is_selected:
		_visualiser.hide()

func _on_selection_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and not _tower.is_selected:
		TowerEvents.emit_tower_selected(_tower)
