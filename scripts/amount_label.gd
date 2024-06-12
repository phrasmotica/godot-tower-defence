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

		if text_label:
			text_label.text = value

@export
var amount := 0:
	set(value):
		amount = value

		if amount_label:
			amount_label.text = default_text if (default_text.length() > 0 and amount == 0) else str(amount)

@export
var default_text := "":
	set(value):
		default_text = value

		if amount_label:
			amount_label.text = value if (value.length() > 0 and amount == 0) else str(amount)
