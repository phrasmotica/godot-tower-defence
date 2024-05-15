class_name BankManager extends Node

@export_range(1, 10)
var starting_money := 10

var current_money := starting_money:
	set(value):
		current_money = value
		print("Now on " + str(current_money) + " money")

		money_changed.emit(current_money)

signal money_changed(new_money: int)

func _ready():
	reset_money()

func reset_money():
	current_money = starting_money
	print("Resetting to " + str(starting_money) + " money")

func can_afford(amount: int):
	return current_money >= amount

func _on_path_waypoints_enemy_died(_enemy:Enemy):
	current_money += 1

func _on_towers_tower_placed(tower: Tower):
	current_money -= tower.price

func _on_game_ui_tower_upgrade_start(_tower:Tower, next_level:TowerLevel):
	current_money -= next_level.price

func _on_towers_tower_sold(sell_value: int):
	current_money += sell_value
