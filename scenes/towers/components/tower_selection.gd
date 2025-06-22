@tool
class_name TowerSelection extends Control

@export
var selection_sprite: AnimatedSprite2D

@export
var selection_visible := true:
	set(value):
		selection_sprite.visible = value

	get:
		return selection_sprite.visible

func enable_mouse() -> void:
	mouse_filter = MOUSE_FILTER_STOP

func disable_mouse() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
