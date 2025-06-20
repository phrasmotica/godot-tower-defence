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

var is_busy := false

func do_warmup():
	if is_busy:
		print("Cannot do warmup, currently busy")
		return

	show_warmup = true
	show_upgrade = false

	warmup_bar.animate()

func do_upgrade():
	if is_busy:
		print("Cannot do upgrade, currently busy")
		return

	show_warmup = false
	show_upgrade = true

	upgrade_bar.animate()

func _on_warmup_progress_bar_started():
	is_busy = true
	warmup_started.emit()

func _on_warmup_progress_bar_finished():
	is_busy = false
	warmup_finished.emit()

func _on_upgrade_progress_bar_started():
	is_busy = true
	upgrade_started.emit()

func _on_upgrade_progress_bar_finished():
	is_busy = false
	upgrade_finished.emit()
