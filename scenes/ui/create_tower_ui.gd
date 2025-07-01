@tool
class_name CreateTowerUI extends Control

@export
var create_tower_buttons: Array[CreateTowerButton]

func _ready() -> void:
	if not Engine.is_editor_hint():
		BankManager.money_changed.connect(_on_bank_manager_money_changed)

		GameEvents.game_started.connect(_on_game_events_game_started)

func _on_bank_manager_money_changed(new_money: int) -> void:
	update_affordability(new_money)

func _on_game_events_game_started(_path_index: int) -> void:
	set_default_mode()

func set_default_mode() -> void:
	for ctb in create_tower_buttons:
		ctb.enable()

func update_affordability(money: int):
	for ctb in create_tower_buttons:
		ctb.update_affordability(money)

func _on_tower_button_create_tower(tower_scene: PackedScene) -> void:
	TowerEvents.emit_tower_created(tower_scene)

func _on_tower_button_cancel_tower() -> void:
	TowerEvents.emit_tower_placing_cancelled()
