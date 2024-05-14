class_name GameUI extends Control

signal buy_gun_tower_button

func _on_gun_tower_button_pressed():
	print("Buying gun tower from UI")

	buy_gun_tower_button.emit()
