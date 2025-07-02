@tool
class_name SellButton extends Button

@export
var tooltip: Tooltip

signal sell_tower

func set_tower(tower: Tower):
	if tower:
		var price = tower.get_sell_price()
		tooltip.text = "Sell this tower for " + str(price) + " money."
	else:
		tooltip.text = ""

func sell():
	tooltip.hide()
	sell_tower.emit()

func _process(_delta):
	if Engine.is_editor_hint():
		return

func _on_pressed():
	Logger.info("Selling tower via button")
	sell()

func _on_mouse_entered():
	tooltip.show()

func _on_mouse_exited():
	tooltip.hide()
