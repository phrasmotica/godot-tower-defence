class_name TowerStateSelling
extends TowerState

func _enter_tree() -> void:
	print("%s has started selling" % _tower.tower_name)

	# this animation calls queue_free() on its end
	_appearance.animate_sell()

	var sell_price := get_sell_price()

	BankManager.earn(sell_price)

func get_sell_price() -> int:
	var upgrade_value := _level_manager.get_total_value()
	return int((_tower.price + upgrade_value) / 2.0)
