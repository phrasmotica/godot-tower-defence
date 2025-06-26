extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_delete"):
		TowerEvents.emit_tower_sold()
