@tool
class_name SellButton extends Button

# HIGH: create separate scene for tooltip
@export
var tooltip: Control

@export
var tooltip_label: Label

signal sell_tower

func set_tower(tower: Tower):
	var price = tower.get_sell_price()
	tooltip_label.text = "Sell this tower for " + str(price) + " money."

func sell():
	tooltip.hide()
	sell_tower.emit()

func _process(_delta):
	if Engine.is_editor_hint():
		return

	# HIGH: move all keyboard shortcuts to a child node of the game UI
	if Input.is_action_just_pressed("ui_text_delete"):
		print("Selling tower via shortcut")
		sell()

func _on_pressed():
	print("Selling tower via button")
	sell()

func _on_mouse_entered():
	tooltip.show()

func _on_mouse_exited():
	tooltip.hide()
