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
