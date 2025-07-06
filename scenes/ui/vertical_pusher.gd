@tool
class_name VerticalPusher
extends VBoxContainer

const ANIMATE_DURATION := 0.1

@export
var to_push: Control

@export_range(0.0, 1.0)
var progress := 0.0:
	set(value):
		progress = clampf(value, 0.0, 1.0)

		_refresh()

@onready
var pusher: Control = %Pusher

func _refresh() -> void:
	if pusher and to_push:
		pusher.custom_minimum_size = progress * to_push.size.y * Vector2.DOWN

func animate_push() -> void:
	if progress <= 0.0:
		progress = 0.0

		var tween := create_tween()
		tween.tween_property(self, "progress", 1.0, ANIMATE_DURATION)

func animate_pull() -> void:
	if progress >= 1.0:
		progress = 1.0

		var tween := create_tween()
		tween.tween_property(self, "progress", 0.0, ANIMATE_DURATION)
