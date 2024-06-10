@tool
class_name TowerProgressBars extends Node2D

@onready
var warmup_bar: TowerProgressBar = $WarmupProgressBar

@onready
var upgrade_bar: TowerProgressBar = $UpgradeProgressBar

@export
var show_warmup := true:
	set(value):
		warmup_bar.visible = value

	get:
		return warmup_bar.visible

@export
var show_upgrade := false:
	set(value):
		upgrade_bar.visible = value

	get:
		return upgrade_bar.visible

signal warmup_started
signal warmup_finished
signal upgrade_started
signal upgrade_finished

# TODO: don't allow starting warmup/upgrade if the other one is in progress

func do_warmup():
	show_warmup = true
	show_upgrade = false

	warmup_bar.animate()

func do_upgrade():
	show_warmup = false
	show_upgrade = true

	upgrade_bar.animate()

func _on_warmup_progress_bar_started():
	warmup_started.emit()

func _on_warmup_progress_bar_finished():
	warmup_finished.emit()

func _on_upgrade_progress_bar_started():
	upgrade_started.emit()

func _on_upgrade_progress_bar_finished():
	upgrade_finished.emit()
