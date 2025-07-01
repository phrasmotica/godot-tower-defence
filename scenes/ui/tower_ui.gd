@tool
class_name TowerUI extends Control

@export
var tower_name_label: Label

@export
var sell_button: SellButton

func _ready() -> void:
	if not Engine.is_editor_hint():
		TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
		TowerEvents.tower_deselected.connect(_on_tower_deselected)

		TowerEvents.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

func set_tower(tower: Tower):
	tower_name_label.text = tower.tower_name if tower else ""

	sell_button.set_tower(tower)

func _on_selected_tower_changed(new_tower: Tower, _old_tower: Tower) -> void:
	set_tower(new_tower)

func _on_tower_deselected() -> void:
	set_tower(null)

func _on_tower_upgrade_finished(tower: Tower, _next_level: TowerLevel) -> void:
	set_tower(tower)

func _on_target_mode_options_item_selected(index: int) -> void:
	TowerEvents.emit_target_mode_changed(index)

func _on_sell_button_sell_tower() -> void:
	TowerEvents.emit_tower_sold()
