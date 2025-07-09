extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_delete"):
		TowerEvents.emit_tower_sold()

	if Input.is_action_just_pressed("next_tower"):
		TowerEvents.emit_next_tower()

	if Input.is_action_just_pressed("previous_tower"):
		TowerEvents.emit_previous_tower()

	if Input.is_action_just_pressed("ui_accept"):
		WaveEvents.emit_wave_requested()
