class_name TowerAppearance
extends Node2D

@export
var selection: TowerSelection

@export
var progress_bars: TowerProgressBars

@export
var visualiser: TowerVisualiser

@export
var level_manager: TowerLevelManager

@export
var animation_player: AnimationPlayer

func adjust_range(projectile_range: float) -> void:
	visualiser.radius = projectile_range

	level_manager.level_adjust_range(projectile_range)
	level_manager.level_adjust_effect_range(projectile_range)

func for_placing() -> void:
	visualiser.show_range()
	visualiser.show_bolt_line = false

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

func show_range() -> void:
	selection.selection_visible = true
	visualiser.show_range()

func hide_range() -> void:
	selection.selection_visible = false
	visualiser.hide_range()

func do_warmup(finished_callback: Callable) -> void:
	progress_bars.warmup_finished.connect(finished_callback)

	progress_bars.do_warmup()

func do_upgrade(finished_callback: Callable) -> void:
	progress_bars.upgrade_finished.connect(finished_callback)

	progress_bars.do_upgrade()

func animate_shoot() -> void:
	if animation_player.current_animation.length() <= 0:
		animation_player.play("shoot")

func animate_pulse() -> void:
	if animation_player.current_animation.length() <= 0:
		animation_player.play("pulse")

func animate_sell() -> void:
	# this animation calls queue_free() on the Tower when it ends
	animation_player.play("sell")
