class_name TowerManager extends Node2D

var all_towers: Array[Tower] = []
var selected_idx := 0
var selected_tower: Tower = null

const default_z_index := 100
const selected_z_index := 600

signal selected_tower_changed(tower: Tower)

func next_tower():
    if all_towers.size() <= 0:
        return

    if all_towers.size() == 1 and selected_tower:
        return

    print("Selecting next tower")

    if selected_tower:
        unhighlight()
        selected_idx = (selected_idx + 1) % all_towers.size()

    selected_tower = all_towers[selected_idx]
    selected_tower_changed.emit(selected_tower)

    highlight()

func previous_tower():
    if all_towers.size() <= 0:
        return

    if all_towers.size() == 1 and selected_tower:
        return

    print("Selecting previous tower")

    if selected_tower:
        unhighlight()
        selected_idx = (selected_idx - 1) % all_towers.size()

    selected_tower = all_towers[selected_idx]
    selected_tower_changed.emit(selected_tower)

    highlight()

func highlight():
    if selected_tower:
        selected_tower.z_index = selected_z_index

func unhighlight():
    if selected_tower:
        selected_tower.z_index = default_z_index

func _on_game_ui_tower_placed(tower: Tower):
    # ensure the tower is not part of the UI anymore
    tower.reparent(self, true)

    tower.on_warmed_up.connect(
        func(t, _first_level):
            all_towers.append(t)
    )

func _on_game_ui_tower_selected(tower: Tower):
    unhighlight()

    selected_tower = tower
    selected_tower_changed.emit(selected_tower)

    highlight()

func _on_game_ui_tower_deselected():
    unhighlight()

    selected_tower = null
    selected_tower_changed.emit(null)

func _on_game_ui_next_tower():
    next_tower()

func _on_game_ui_previous_tower():
    previous_tower()
