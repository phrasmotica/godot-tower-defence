class_name GameManager extends Node

const FAST_FORWARD_SPEED := 3

func _process(_delta):
	if Input.is_action_just_pressed("fast_forward"):
		speed_up()

	if Input.is_action_just_released("fast_forward"):
		speed_regular()

func speed_up():
	Engine.time_scale = FAST_FORWARD_SPEED

func speed_regular():
	Engine.time_scale = 1
