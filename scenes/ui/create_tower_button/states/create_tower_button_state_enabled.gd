class_name CreateTowerButtonStateEnabled
extends CreateTowerButtonState

func _enter_tree() -> void:
	print("CreateTowerButton is now enabled")

	_button.disabled = false

	_button.mouse_filter = Control.MOUSE_FILTER_STOP

	_button.mouse_entered.connect(_on_mouse_entered)
	_button.mouse_exited.connect(_on_mouse_exited)
	_button.pressed.connect(_on_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(_button.action_name):
		print("Creating tower via shortcut")

		transition_state(CreateTowerButton.State.CREATING)

func _on_mouse_entered() -> void:
	_button.tooltip.show()

func _on_mouse_exited() -> void:
	_button.tooltip.hide()

func _on_pressed() -> void:
	print("Creating tower via button")

	transition_state(CreateTowerButton.State.CREATING)
