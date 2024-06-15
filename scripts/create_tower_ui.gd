@tool
class_name CreateTowerUI extends Control

@export
var create_tower_buttons: Array[CreateTowerButton]

signal create_tower(tower_scene: PackedScene)
signal cancel_tower

func start_game():
	for ctb in create_tower_buttons:
		ctb.enable_button()

func set_default_mode():
	for ctb in create_tower_buttons:
		ctb.is_creating_mode = false

func set_default_mode_except(tower_scene: PackedScene):
	for ctb in create_tower_buttons:
		if ctb.tower != tower_scene:
			ctb.is_creating_mode = false

func update_affordability(money: int):
	for ctb in create_tower_buttons:
		ctb.update_affordability(money)

func _on_tower_button_create_tower(tower_scene: PackedScene):
	create_tower.emit(tower_scene)

func _on_tower_button_cancel_tower():
	cancel_tower.emit()
