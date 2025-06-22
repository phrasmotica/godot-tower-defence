@tool
class_name CreateTowerUI extends Control

@export
var create_tower_buttons: Array[CreateTowerButton]

signal create_tower(tower_scene: PackedScene)
signal cancel_tower

func _ready() -> void:
	if not Engine.is_editor_hint():
		BankManager.money_changed.connect(_on_bank_manager_money_changed)

		GameEvents.game_started.connect(_on_game_events_game_started)

func _on_bank_manager_money_changed(new_money: int) -> void:
	update_affordability(new_money)

func _on_game_events_game_started(_path_index: int) -> void:
	start_game()

func start_game():
	for ctb in create_tower_buttons:
		ctb.start_game()

func set_default_mode() -> void:
	for ctb in create_tower_buttons:
		ctb.is_creating_mode = false

func set_default_mode_except(tower_scene: PackedScene) -> void:
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
