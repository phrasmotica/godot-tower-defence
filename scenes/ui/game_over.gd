class_name GameOver extends Control

signal restart

func _ready() -> void:
	LivesManager.lives_depleted.connect(_on_lives_manager_lives_depleted)

func _on_restart_button_pressed():
	Logger.info("Restarting game")
	get_tree().reload_current_scene()
	restart.emit()

func _on_lives_manager_lives_depleted():
	Logger.info("Game over!")
	show()
