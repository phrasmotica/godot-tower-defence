extends Node

const STARTING_MONEY := 10

var _current_money := STARTING_MONEY

signal money_changed(old_money: int, new_money: int)

func _ready() -> void:
	EnemyEvents.enemy_died.connect(
		func(enemy: Enemy) -> void:
			earn(enemy.get_bounty())
	)

	reset_money()

func _set_money(amount: int) -> void:
	var old_money := _current_money

	_current_money = amount
	Logger.debug("Now on %d money" % _current_money)

	emit_money_changed(old_money, _current_money)

func reset_money() -> void:
	Logger.info("Resetting to %d money" % STARTING_MONEY)
	_set_money(STARTING_MONEY)

func get_money() -> int:
	return _current_money

func can_afford(amount: int) -> bool:
	return _current_money >= amount

func earn(amount: int) -> void:
	_set_money(_current_money + amount)

func deduct(amount: int) -> void:
	_set_money(_current_money - amount)

func emit_money_changed(old_money: int, new_money: int) -> void:
	money_changed.emit(old_money, new_money)
