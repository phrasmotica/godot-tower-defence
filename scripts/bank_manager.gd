class_name BankManager extends Node

@export_range(1, 10)
var starting_money: int = 10

var current_money = starting_money

signal money_changed(new_money: int)

func _ready():
	reset_money()

func reset_money():
	set_money(starting_money)
	print("Resetting to " + str(starting_money) + " money")

func add_money(amount):
	set_money(current_money + amount)
	print("Now on " + str(current_money) + " money")

func set_money(money):
	current_money = money
	money_changed.emit(current_money)

func can_afford(amount: int):
	return current_money >= amount

func _on_path_waypoints_enemy_died(_enemy:Enemy):
	add_money(1)

func _on_towers_tower_placed(tower: Tower):
	add_money(-tower.price)

func _on_towers_tower_upgrade_start(_tower: Tower, next_level: TowerLevel):
	add_money(-next_level.price)
