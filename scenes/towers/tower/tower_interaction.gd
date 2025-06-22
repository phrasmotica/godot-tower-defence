class_name TowerInteraction
extends Node

@export
var selection: TowerSelection

signal mouse_entered
signal mouse_exited
signal clicked

var _is_selected := false

func _ready() -> void:
	selection.mouse_entered.connect(mouse_entered.emit)
	selection.mouse_exited.connect(mouse_exited.emit)
	selection.gui_input.connect(_on_selection_gui_input)

func enable_mouse() -> void:
	selection.enable_mouse()

func disable_mouse() -> void:
	selection.disable_mouse()

func show_selection() -> void:
	selection.selection_visible = true

func hide_selection() -> void:
	selection.selection_visible = false

func set_selected(selected: bool) -> void:
	_is_selected = selected

func is_selected() -> bool:
	return _is_selected

func _on_selection_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		clicked.emit()
