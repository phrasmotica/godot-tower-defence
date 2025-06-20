@tool
class_name Tooltip extends Control

@export
var label: Label

@export_multiline
var text := "":
	set(value):
		if label:
			label.text = value

	get:
		return label.text if label else ""

func _on_background_resized():
	# background node is a panel container, so shrinks to the
	# correct size after the tooltip content gets updated
	size = get_node("Background").size
