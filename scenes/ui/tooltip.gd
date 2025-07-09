@tool
class_name Tooltip extends PanelContainer

@export_multiline
var text := "":
	set(value):
		if label:
			label.text = value

	get:
		return label.text if label else ""

@onready
var label: Label = %Description
