@tool
class_name TowerInteraction
extends Node

@export
var range_radius := 3.0:
	set(value):
		range_radius = value

		_refresh()

@export
var scan_duration := 5.0:
	set(value):
		scan_duration = value

		_refresh()

@export
var show_firing_line := false:
	set(value):
		show_firing_line = value

		_refresh()

@export
var designer: TowerDesigner

@onready
var progress_bars: TowerProgressBars = %ProgressBars

@onready
var visualiser: TowerVisualiser = %Visualiser

@onready
var selection: TowerSelection = %Selection

signal mouse_entered
signal mouse_exited
signal clicked

var _is_selected := false

func _ready() -> void:
	if not Engine.is_editor_hint():
		selection.mouse_entered.connect(mouse_entered.emit)
		selection.mouse_exited.connect(mouse_exited.emit)
		selection.gui_input.connect(_on_selection_gui_input)

	if designer:
		designer \
			.level_projectile_stats_changed \
			.connect(_on_level_projectile_stats_changed)

		designer \
			.level_effect_stats_changed \
			.connect(_on_level_effect_stats_changed)

	_refresh()

func _refresh() -> void:
	if visualiser:
		visualiser.radius = range_radius
		visualiser.scan_duration = scan_duration
		visualiser.show_bolt_line = show_firing_line

func _on_level_projectile_stats_changed(stats: TowerLevelStats) -> void:
	range_radius = stats.projectile_range

func _on_level_effect_stats_changed(stats: EffectStats) -> void:
	range_radius = stats.effect_range

func for_placing() -> void:
	visualiser.show_range()
	visualiser.show_bolt_line = false

func set_level(level: TowerLevel) -> void:
	range_radius = level.get_range(true)
	scan_duration = 10.0 / level.projectile_stats.rotate_speed

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
	visualiser.show_range()

func hide_range() -> void:
	visualiser.hide_range()

func animate_range(animate: bool) -> void:
	visualiser.animate_range(animate)

func enable_mouse() -> void:
	selection.enable_mouse()

func disable_mouse() -> void:
	selection.disable_mouse()

func show_selection() -> void:
	selection.selection_visible = true

func hide_selection() -> void:
	selection.selection_visible = false

func set_selected(selected: bool) -> void:
	_is_selected = selected

func is_selected() -> bool:
	return _is_selected

func do_warmup(finished_callback: Callable) -> void:
	progress_bars.warmup_finished.connect(finished_callback)

	progress_bars.do_warmup()

func do_upgrade(finished_callback: Callable) -> void:
	progress_bars.upgrade_finished.connect(finished_callback)

	progress_bars.do_upgrade()

func _on_selection_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		clicked.emit()
