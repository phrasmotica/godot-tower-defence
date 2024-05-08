class_name GunBarrel extends Node2D

signal shoot

func _on_shot_timer_timeout():
	shoot.emit()
