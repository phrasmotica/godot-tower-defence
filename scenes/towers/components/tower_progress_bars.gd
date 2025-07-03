@tool
class_name TowerProgressBars extends Node2D

enum DisplayMode { NONE, WARMUP, UPGRADE }

@onready
var warmup_bar: TowerProgressBar = %WarmupProgressBar

@onready
var upgrade_bar: TowerProgressBar = %UpgradeProgressBar

@export
var display_mode := DisplayMode.NONE:
	set(value):
		display_mode = value

		_refresh()

signal warmup_started
signal warmup_finished
signal upgrade_started
signal upgrade_finished

func _ready() -> void:
	warmup_bar.started.connect(_on_warmup_progress_bar_started)
	warmup_bar.finished.connect(_on_warmup_progress_bar_finished)

	upgrade_bar.started.connect(_on_upgrade_progress_bar_started)
	upgrade_bar.finished.connect(_on_upgrade_progress_bar_finished)

	if Engine.is_editor_hint():
		display_mode = DisplayMode.WARMUP
	else:
		display_mode = DisplayMode.NONE

	_refresh()

func _refresh() -> void:
	if warmup_bar:
		warmup_bar.visible = display_mode == DisplayMode.WARMUP

	if upgrade_bar:
		upgrade_bar.visible = display_mode == DisplayMode.UPGRADE

func do_warmup() -> void:
	if display_mode == DisplayMode.NONE:
		display_mode = DisplayMode.WARMUP
		warmup_bar.animate()
	else:
		Logger.error("Cannot do warmup, currently busy")

func do_upgrade() -> void:
	if display_mode == DisplayMode.NONE:
		display_mode = DisplayMode.UPGRADE

		upgrade_bar.animate()
	else:
		Logger.error("Cannot do upgrade, currently busy")

func _on_warmup_progress_bar_started() -> void:
	warmup_started.emit()

func _on_warmup_progress_bar_finished() -> void:
	display_mode = DisplayMode.NONE
	warmup_finished.emit()

func _on_upgrade_progress_bar_started() -> void:
	upgrade_started.emit()

func _on_upgrade_progress_bar_finished() -> void:
	display_mode = DisplayMode.NONE
	upgrade_finished.emit()
