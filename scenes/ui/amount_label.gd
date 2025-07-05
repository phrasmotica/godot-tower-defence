@tool
class_name AmountLabel extends HBoxContainer

@export
var icon: Texture2D:
	set(value):
		icon = value

		_refresh()

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
var vertical_layout := false:
	set(value):
		vertical_layout = value

		_refresh()

@export
var default_text := "":
	set(value):
		default_text = value

		_refresh()

@onready
var header_container: HBoxContainer = %HeaderContainer

@onready
var vertical_container: VBoxContainer = %VerticalContainer

@onready
var texture_rect: TextureRect = %TextureRect

@onready
var text_label: Label = %Text

@onready
var amount_label: Label = %Amount

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	if vertical_layout:
		alignment = BoxContainer.ALIGNMENT_CENTER

		if vertical_container:
			vertical_container.show()

			if header_container:
				header_container.reparent(vertical_container)
				header_container.alignment = BoxContainer.ALIGNMENT_CENTER

			if text_label:
				text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

			if amount_label:
				amount_label.reparent(vertical_container)
				amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		alignment = BoxContainer.ALIGNMENT_BEGIN

		if vertical_container:
			vertical_container.hide()

		if header_container:
			header_container.reparent(self)
			header_container.alignment = BoxContainer.ALIGNMENT_BEGIN

		if text_label:
			text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

		if amount_label:
			amount_label.reparent(self)
			amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	if icon:
		if text_label:
			text_label.hide()
			text_label.text = ""

		if texture_rect:
			texture_rect.show()
			texture_rect.texture = icon
	else:
		if texture_rect:
			texture_rect.hide()
			texture_rect.texture = null

		if text_label:
			text_label.show()
			text_label.text = text

	if amount_label:
		amount_label.text = default_text if (default_text.length() > 0 and amount == 0) else str(amount)
