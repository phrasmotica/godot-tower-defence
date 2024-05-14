class_name GameUI extends Control

@onready var money_amount = $ColorRect/MoneyLabel/Amount
@onready var lives_amount = $ColorRect/LivesLabel/Amount

signal buy_gun_tower_button

func _on_gun_tower_button_pressed():
	print("Buying gun tower from UI")

	buy_gun_tower_button.emit()

func _on_bank_manager_money_changed(new_money:int):
	if money_amount:
		money_amount.text = str(new_money)

func _on_lives_manager_lives_changed(new_lives):
	if lives_amount:
		lives_amount.text = str(new_lives)
