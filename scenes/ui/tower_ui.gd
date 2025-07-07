@tool
class_name TowerUI extends PanelContainer

@onready
var tower_name_label: Label = %TowerNameLabel

@onready
var target_mode_options: OptionButton = %TargetModeOptions

@onready
var sell_button: SellButton = %SellButton

func _ready() -> void:
	if not Engine.is_editor_hint():
		TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
		TowerEvents.tower_deselected.connect(_on_tower_deselected)

		TowerEvents.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

		target_mode_options.item_selected.connect(_on_target_mode_options_item_selected)

		sell_button.sell_tower.connect(_on_sell_button_sell_tower)

func set_tower(tower: Tower) -> void:
	tower_name_label.text = tower.tower_name if tower else ""

	sell_button.set_tower(tower)

func _on_selected_tower_changed(new_tower: Tower, _old_tower: Tower) -> void:
	set_tower(new_tower)

func _on_tower_deselected() -> void:
	set_tower(null)

func _on_tower_upgrade_finished(_index: int, tower: Tower, _next_level: TowerLevel) -> void:
	set_tower(tower)

func _on_target_mode_options_item_selected(index: int) -> void:
	TowerEvents.emit_target_mode_changed(index)

func _on_sell_button_sell_tower() -> void:
	TowerEvents.emit_tower_sold()
