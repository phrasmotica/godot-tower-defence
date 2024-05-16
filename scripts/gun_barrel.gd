class_name GunBarrel extends Node2D

@onready var timer = $ShotTimer

signal shoot

func start_timer(timeout: float):
	timer.wait_time = timeout
	timer.start()

func stop_firing():
	timer.stop()

func _on_shot_timer_timeout():
	shoot.emit()
