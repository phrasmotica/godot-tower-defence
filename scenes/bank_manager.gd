extends Node

const STARTING_MONEY := 10

var current_money := STARTING_MONEY:
	set(value):
		current_money = value
		print("Now on " + str(current_money) + " money")

		money_changed.emit(current_money)

signal money_changed(new_money: int)

func _ready():
	reset_money()

func reset_money():
	current_money = STARTING_MONEY
	print("Resetting to " + str(STARTING_MONEY) + " money")

func can_afford(amount: int):
	return current_money >= amount

func _on_game_ui_tower_placed(tower: Tower):
	current_money -= tower.price

func _on_game_ui_selected_tower_handled():
	# allows tower upgrade buttons to update their state
	money_changed.emit(current_money)

func _on_towers_tower_upgrade_start(_tower:Tower, next_level:TowerLevel):
	current_money -= next_level.price

func _on_towers_tower_sold(sell_value:int):
	current_money += sell_value

func _on_game_ui_tower_upgrade_finish(_tower: Tower, _next_level: TowerLevel):
	# allows tower upgrade buttons to update their state
	money_changed.emit(current_money)

func _on_path_manager_enemy_died(enemy: Enemy):
	print("Bounty: " + str(enemy.bounty))
	current_money += enemy.bounty
