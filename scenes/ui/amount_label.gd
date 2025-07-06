@tool
class_name AmountLabel extends HBoxContainer

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

@export_group("Label")

@export
var text := "":
	set(value):
		text = value

		_refresh()

@export_group("Icon")

@export
var icon: Texture2D:
	set(value):
		icon = value

		_refresh()

@export_range(32.0, 128.0)
var icon_size := 40.0:
	set(value):
		icon_size = value

		_refresh()

@export
var icon_colour := Color.WHITE:
	set(value):
		icon_colour = value

		_refresh()

@export_group("Layout")

@export
var vertical_layout := false:
	set(value):
		vertical_layout = value

		_refresh()

@export
var amount_text_size := 28:
	set(value):
		amount_text_size = value

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

var _icon_updater: ShaderTimeUpdater = null

func _ready() -> void:
	var icon_material := texture_rect.material as ShaderMaterial
	assert(icon_material)

	_icon_updater = ShaderTimeUpdater.new(icon_material)

	_refresh()

func _refresh() -> void:
	if _icon_updater:
		_icon_updater.set_color("replacement_colour", icon_colour)

	if amount_label:
		amount_label.add_theme_font_size_override("font_size", amount_text_size)

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
			amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT if icon else HORIZONTAL_ALIGNMENT_RIGHT

	if icon:
		if text_label:
			text_label.hide()
			text_label.text = ""

		if texture_rect:
			texture_rect.show()
			texture_rect.texture = icon
			texture_rect.custom_minimum_size = icon_size * Vector2.ONE
	else:
		if texture_rect:
			texture_rect.hide()
			texture_rect.texture = null

		if text_label:
			text_label.show()
			text_label.text = text

	if amount_label:
		amount_label.text = default_text if (default_text.length() > 0 and amount == 0) else str(amount)
