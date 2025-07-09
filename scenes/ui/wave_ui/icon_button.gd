@tool
class_name IconButton
extends Button

@export
var texture: Texture2D:
	set(value):
		texture = value

		_refresh()

@export
var texture_size := 32.0 * Vector2.ONE:
	set(value):
		texture_size = value

		_refresh()

@export
var texture_colour := Color.WHITE:
	set(value):
		texture_colour = value

		_refresh()

@onready
var texture_rect: TextureRect = %TextureRect

var _updater: ShaderUpdater = null

func _ready() -> void:
	var texture_material := texture_rect.material as ShaderMaterial
	assert(texture_material)

	_updater = ShaderUpdater.new(texture_material)

	_refresh()

func _refresh() -> void:
	if texture_rect:
		texture_rect.custom_minimum_size = texture_size
		texture_rect.texture = texture

	if _updater:
		_updater.set_color("replacement_colour", texture_colour)
