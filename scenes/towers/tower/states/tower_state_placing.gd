class_name TowerStatePlacing
extends TowerState

var _is_mouse_over_path := false
var _is_valid_location := false

func _enter_tree() -> void:
	print("Tower is now placing")

	_tower.deselect()

	var current_level := _level_manager.get_current_level()
	_tower.adjust_range(current_level.get_range(true))

	_collision_area.body_entered.connect(_on_collision_area_body_entered)
	_collision_area.body_exited.connect(_on_collision_area_body_exited)

	_selection.selection_visible = false
	_selection.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_visualiser.show_range()
	_visualiser.show_bolt_line = false

	_path_manager.mouse_validity_changed.connect(_on_path_manager_mouse_validity_changed)
	_path_manager.valid_area_clicked.connect(_on_path_manager_valid_area_clicked)

func _process(_delta: float) -> void:
	if not _tower.visible:
		_tower.show()

	_tower.global_position = get_viewport().get_mouse_position()

# NOTE: Area2D handling a collision with a TileSet's physics layer
# must use body_entered/exited rather than area_entered/exited!!
func _on_collision_area_body_entered(_body: Node2D) -> void:
	print(_tower.tower_name + " entered path area")
	_is_valid_location = false
	_visualiser.set_error_look()

func _on_collision_area_body_exited(_body: Node2D) -> void:
	print(_tower.tower_name + " exited path area")
	_is_valid_location = true
	_visualiser.set_default_look()

func _on_path_manager_mouse_validity_changed(is_valid: bool) -> void:
	_is_mouse_over_path = is_valid

	if _is_mouse_over_path:
		_visualiser.show()
		_visualiser.set_default_look()
	else:
		_visualiser.hide()
		_visualiser.set_error_look()

func _on_path_manager_valid_area_clicked() -> void:
	if not (_is_mouse_over_path and _is_valid_location):
		print("Cannot place tower here!")
		return

	print("Placed new %s" % _tower.tower_name)

	BankManager.deduct(_tower.price)

	TowerEvents.emit_tower_placing_finished(_tower)

	transition_state(Tower.State.WARMUP)

func is_placing() -> bool:
	return true
