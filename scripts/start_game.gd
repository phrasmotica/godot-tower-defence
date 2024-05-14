class_name StartGame extends Control

signal start

func _ready():
	show()

func _on_start_button_pressed():
	print("Starting game")
	hide()
	start.emit()
