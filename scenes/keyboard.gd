extends Node

signal sell_tower

func _process(_delta):
	if Input.is_action_just_pressed("ui_text_delete"):
		print("Selling tower via shortcut")
		sell_tower.emit()
