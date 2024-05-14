class_name GameOver extends Control

signal restart

func _on_restart_button_pressed():
	print("Restarting game")
	restart.emit()
