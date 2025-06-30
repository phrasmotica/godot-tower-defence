class_name Shrinker
extends Node

@export
var duration_seconds := 0.1

var _target: Node2D = null

func _init(target: Node2D) -> void:
	_target = target

func _enter_tree() -> void:
	var tween := create_tween()
	tween.tween_property(_target, "scale", Vector2.ZERO, duration_seconds)
	tween.tween_callback(_target.queue_free).set_delay(duration_seconds)
