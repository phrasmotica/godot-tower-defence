class_name GameUIAppearance
extends Node

@export
var create_tower_ui: CreateTowerUI

@export
var animation_player: AnimationPlayer

var _is_animated_in := false

# TODO: use the Tower or TowerPlacing signal bus for these instead
signal create_tower(tower_scene: PackedScene)
signal cancel_tower

func _ready() -> void:
	create_tower_ui.create_tower.connect(create_tower.emit)
	create_tower_ui.cancel_tower.connect(cancel_tower.emit)

func default_mode() -> void:
	create_tower_ui.set_default_mode()

func default_mode_except(tower_scene: PackedScene) -> void:
	create_tower_ui.set_default_mode_except(tower_scene)

func animate_show_ui() -> void:
	animation_player.play("show_tower_ui")
	_is_animated_in = true

func animate_hide_ui() -> void:
	if _is_animated_in:
		animation_player.play("hide_tower_ui")
		_is_animated_in = false
