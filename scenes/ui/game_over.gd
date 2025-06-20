class_name GameOver extends Control

signal restart

func _on_restart_button_pressed():
	print("Restarting game")
	get_tree().reload_current_scene()
	restart.emit()

func _on_lives_manager_lives_depleted():
	print("Game over!")
	show()
