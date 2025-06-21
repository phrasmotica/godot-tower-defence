class_name TowerStatePlacing
extends TowerState

var _is_mouse_over_path := false
var _is_valid_location := false

func _enter_tree() -> void:
	print("Tower is now placing")

	TowerPlacingEvents.mouse_over_path_area_changed.connect(_on_mouse_over_path_area_changed)

	_tower.deselect()

	var current_level := _level_manager.get_current_level()
	_tower.adjust_range(current_level.get_range(true))

	_collision_area.body_entered.connect(_on_collision_area_body_entered)
	_collision_area.body_exited.connect(_on_collision_area_body_exited)

	_selection.selection_visible = false

	_visualiser.show_range()
	_visualiser.show_bolt_line = false

func _process(_delta: float) -> void:
	if not _tower.visible:
		_tower.show()

	_tower.global_position = get_viewport().get_mouse_position()

func _on_mouse_over_path_area_changed(is_over: bool) -> void:
	_is_mouse_over_path = is_over

	if _is_mouse_over_path:
		_tower.show_visualiser()
		_tower.set_default_look()
	else:
		_tower.hide_visualiser()
		_tower.set_error_look()

# NOTE: Area2D handling a collision with a TileSet's physics layer
# must use body_entered/exited rather than area_entered/exited!!
func _on_collision_area_body_entered(_body: Node2D) -> void:
	print(_tower.tower_name + " entered path area")
	_is_valid_location = false
	_tower.set_error_look()

func _on_collision_area_body_exited(_body: Node2D) -> void:
	print(_tower.tower_name + " exited path area")
	_is_valid_location = true
	_tower.set_default_look()

func is_placing() -> bool:
	return true

func can_be_placed() -> bool:
	return _is_mouse_over_path and _is_valid_location
