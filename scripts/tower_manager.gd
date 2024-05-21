class_name TowerManager extends Node2D

var all_towers: Array[Tower] = []
var selected_idx := 0
var selected_tower: Tower = null

const default_z_index := 100
const selected_z_index := 600

func add_tower(tower: Tower):
	# ensure the tower is not part of the UI anymore
    tower.reparent(self, true)

    tower.on_warmed_up.connect(
        func(t, _first_level):
            all_towers.append(t)
    )

func next_tower():
    if all_towers.size() <= 0:
        return null

    print("Selecting next tower")

    if not selected_tower:
        return all_towers[selected_idx]

    selected_idx = (selected_idx + 1) % all_towers.size()
    return all_towers[selected_idx]

func previous_tower():
    if all_towers.size() <= 0:
        return null

    print("Selecting previous tower")

    if not selected_tower:
        return all_towers[selected_idx]

    selected_idx = (selected_idx - 1) % all_towers.size()
    return all_towers[selected_idx]

func _on_game_ui_tower_selected(tower: Tower):
    if selected_tower:
        selected_tower.z_index = default_z_index

    # ensure only the selected tower appears above the game tint
    selected_tower = tower
    selected_tower.z_index = selected_z_index

func _on_game_ui_tower_deselected():
    selected_tower.z_index = default_z_index
    selected_tower = null
