@tool
class_name Tooltip extends PanelContainer

@export_multiline
var text := "":
	set(value):
		text = value

		_refresh()

@onready
var label: Label = %Description

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if label:
		label.text = text
