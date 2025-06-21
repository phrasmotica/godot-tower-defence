@tool
class_name AmountLabel extends Control

@export
var text_label: Label

@export
var amount_label: Label

@export
var text := "":
	set(value):
		text = value

		_refresh()

@export
var amount := 0:
	set(value):
		amount = value

		_refresh()

@export
var default_text := "":
	set(value):
		default_text = value

		_refresh()

func _refresh() -> void:
	if text_label:
		text_label.text = text

	if amount_label:
		amount_label.text = default_text if (default_text.length() > 0 and amount == 0) else str(amount)
