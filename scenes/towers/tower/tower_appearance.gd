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
var visualiser: TowerVisualiser

@export
var animation_player: AnimationPlayer

func _ready() -> void:
	if designer:
		designer.adjust_sprite.connect(set_sprite)
		designer.adjust_range.connect(set_range)
		designer.adjust_effect_range.connect(set_range)

func adjust_range(projectile_range: float) -> void:
	visualiser.radius = projectile_range

func for_placing() -> void:
	visualiser.show_range()
	visualiser.show_bolt_line = false

func for_firing() -> void:
	level_sprite.modulate = normal_colour

func default_look() -> void:
	visualiser.show()
	visualiser.set_default_look()

func error_look() -> void:
	visualiser.show()
	visualiser.set_error_look()

func show_visualiser() -> void:
	visualiser.show()

func hide_visualiser() -> void:
	visualiser.hide()

func set_sprite(sprite: Texture2D) -> void:
	level_sprite.texture = sprite

func set_range(radius: float) -> void:
	visualiser.radius = radius

func show_range() -> void:
	visualiser.show_range()

func hide_range() -> void:
	visualiser.hide_range()

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

func animate_sell() -> void:
	# this animation calls queue_free() on the Tower when it ends
	animation_player.play("sell")
