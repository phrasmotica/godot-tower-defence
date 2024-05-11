class_name GunBarrel extends Node2D

signal shoot

func _on_shot_timer_timeout():
	# TODO: this shouldn't start until the tower has finished warming up/upgrading
	shoot.emit()
