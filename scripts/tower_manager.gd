class_name TowerManager extends Node2D

var selected_tower: Tower

const default_z_index := 100
const selected_z_index := 600

func _on_game_ui_tower_selected(tower: Tower):
    if selected_tower:
        selected_tower.z_index = default_z_index

    # ensure only the selected tower appears above the game tint
    selected_tower = tower
    selected_tower.z_index = selected_z_index

func _on_game_ui_tower_deselected():
    selected_tower.z_index = default_z_index
    selected_tower = null
