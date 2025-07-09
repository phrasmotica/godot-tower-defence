extends Node

const FAST_FORWARD_SPEED := 3

func _ready() -> void:
	SpeedEvents.speed_fast_requested.connect(speed_up)
	SpeedEvents.speed_normal_requested.connect(speed_regular)

func speed_up() -> void:
	Engine.time_scale = FAST_FORWARD_SPEED

func speed_regular() -> void:
	Engine.time_scale = 1
