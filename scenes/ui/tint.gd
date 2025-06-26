extends ColorRect

func _ready() -> void:
	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)
	TowerEvents.tower_sold.connect(_on_tower_sold)

func _on_selected_tower_changed(_tower: Tower, _old_tower: Tower) -> void:
	show()

func _on_tower_deselected() -> void:
	hide()

func _on_tower_sold() -> void:
	hide()
