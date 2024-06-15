class_name CreateTowerUI extends Control

signal create_tower(tower_scene: PackedScene)
signal cancel_tower

func _on_tower_button_create_tower(tower_scene: PackedScene):
	create_tower.emit(tower_scene)

func _on_tower_button_cancel_tower():
	cancel_tower.emit()
