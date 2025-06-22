class_name TowerStatePlacing
extends TowerState

var _is_mouse_over_path := false
var _is_valid_location := false

func _enter_tree() -> void:
	print("Tower is now placing")

	_colliders.path_area_entered.connect(_on_path_area_entered)
	_colliders.path_area_exited.connect(_on_path_area_exited)

	_interaction.hide_selection()
	_interaction.disable_mouse()

	_appearance.for_placing()

	PathInteraction.mouse_validity_changed.connect(_on_mouse_validity_changed)
	PathInteraction.valid_area_clicked.connect(_on_valid_area_clicked)

func _process(_delta: float) -> void:
	if not _tower.visible:
		_tower.show()

	_tower.global_position = get_viewport().get_mouse_position()

func _on_path_area_entered() -> void:
	print(_tower.tower_name + " entered path area")
	_is_valid_location = false

	_appearance.error_look()

func _on_path_area_exited() -> void:
	print(_tower.tower_name + " exited path area")
	_is_valid_location = true

	_appearance.default_look()

func _on_mouse_validity_changed(is_valid: bool) -> void:
	_is_mouse_over_path = is_valid

	if _is_mouse_over_path:
		_appearance.default_look()
	else:
		_appearance.error_look()

func _on_valid_area_clicked() -> void:
	if not (_is_mouse_over_path and _is_valid_location):
		print("Cannot place tower here!")
		return

	print("Placed new %s" % _tower.tower_name)

	BankManager.deduct(_tower.price)

	TowerEvents.emit_tower_placing_finished(_tower)

	transition_state(Tower.State.WARMUP)
