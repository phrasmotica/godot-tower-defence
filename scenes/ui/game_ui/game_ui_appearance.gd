class_name GameUIAppearance
extends Node

@export
var create_tower_ui: CreateTowerUI

@export
var animation_player: AnimationPlayer

var _is_animated_in := false

func default_mode() -> void:
	create_tower_ui.set_default_mode()

func animate_show_ui() -> void:
	animation_player.play("show_tower_ui")
	_is_animated_in = true

func animate_hide_ui() -> void:
	if _is_animated_in:
		animation_player.play("hide_tower_ui")
		_is_animated_in = false
