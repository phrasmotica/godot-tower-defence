class_name CreateTowerButtonStateCreating
extends CreateTowerButtonState

var _original_icon: Texture2D = null

func _enter_tree() -> void:
	print("CreateTowerButton is now creating")

	TowerEvents.emit_tower_created(_button.tower)

	_button.tooltip.hide()

	_original_icon = _button.icon
	_button.icon = null

	_button.mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	TowerEvents.emit_tower_placing_cancelled()

	transition_state(CreateTowerButton.State.ENABLED)

func _exit_tree() -> void:
	_button.icon = _original_icon
