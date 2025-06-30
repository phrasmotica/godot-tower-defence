class_name TowerStatePlacing
extends TowerState

var _is_mouse_over_path := true
var _is_valid_location := true

func _enter_tree() -> void:
	if _skip_setup:
		_skip_setup = false
		print("TowerStatePlacing: %s skipping setup" % _info.get_name())
		return

	print("Tower is now placing")

	_colliders.path_area_entered.connect(_on_path_area_entered)
	_colliders.path_area_exited.connect(_on_path_area_exited)

	_interaction.hide_selection()
	_interaction.disable_mouse()
	_interaction.for_placing()

	PathInteraction.mouse_validity_changed.connect(_on_mouse_validity_changed)
	PathInteraction.valid_area_clicked.connect(_on_valid_area_clicked)

func _process(_delta: float) -> void:
	if not _tower.visible:
		_tower.show()

	_tower.global_position = get_viewport().get_mouse_position()

func _on_path_area_entered() -> void:
	print(_info.get_name() + " entered path area")
	_is_valid_location = false

	_interaction.error_look()

func _on_path_area_exited() -> void:
	print(_info.get_name() + " exited path area")
	_is_valid_location = true

	_interaction.default_look()

func _on_mouse_validity_changed(is_valid: bool) -> void:
	_is_mouse_over_path = is_valid

	if _is_mouse_over_path:
		_interaction.default_look()
	else:
		_interaction.error_look()

func _on_valid_area_clicked() -> void:
	if not (_is_mouse_over_path and _is_valid_location):
		print("Cannot place tower here!")
		return

	print("Placed new %s" % _info.get_name())

	BankManager.deduct(_info.get_price())

	TowerEvents.emit_tower_placing_finished(_tower)

	transition_state(Tower.State.WARMUP)
