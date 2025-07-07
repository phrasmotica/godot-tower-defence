class_name GameUIAppearance
extends Node

@export
var tower_ui_pusher: VerticalPusher

func hide_tower_ui() -> void:
	tower_ui_pusher.progress = 1.0

func animate_show_ui() -> void:
	tower_ui_pusher.animate_pull()

func animate_hide_ui() -> void:
	tower_ui_pusher.animate_push()
