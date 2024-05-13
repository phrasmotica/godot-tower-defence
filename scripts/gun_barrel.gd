class_name GunBarrel extends Node2D

@onready var timer = $ShotTimer

signal shoot

func set_timeout(timeout: float):
	timer.wait_time = timeout

func _on_shot_timer_timeout():
	# TODO: this shouldn't start until the tower has finished warming up/upgrading
	shoot.emit()
