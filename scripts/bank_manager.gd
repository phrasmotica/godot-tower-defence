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
	set_money(max(0, current_money + amount))
	print("Now on " + str(current_money) + " money")

func set_money(money):
	current_money = money
	money_changed.emit(current_money)
