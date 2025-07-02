@tool
class_name TowerAppearance
extends Node2D

const normal_colour := Color.WHITE

@export
var progress_colour := Color8(255, 255, 255, 80)

@export
var designer: TowerDesigner

@export
var level_sprite: Sprite2D

@export
var animation_player: AnimationPlayer

func _ready() -> void:
	if designer:
		designer.level_changed.connect(_on_level_changed)

func for_firing() -> void:
	level_sprite.modulate = normal_colour

func _on_level_changed(level: TowerLevel) -> void:
	set_level(level)

func set_level(level: TowerLevel) -> void:
	level_sprite.texture = level.sprite

func do_warmup() -> void:
	level_sprite.modulate = progress_colour

func do_upgrade() -> void:
	level_sprite.modulate = progress_colour

func animate_shoot() -> void:
	if animation_player.current_animation.length() <= 0:
		animation_player.play("shoot")

func animate_pulse() -> void:
	if animation_player.current_animation.length() <= 0:
		animation_player.play("pulse")
