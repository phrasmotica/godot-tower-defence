@tool
class_name PathManager extends Node2D

@export
var paths: Array[Path] = []

@export
var active_path_index: int:
	set(value):
		var new_value = clampi(value, 0, paths.size() - 1)

		if active_path_index != new_value:
			active_path_index = new_value

			set_active_path()

var is_mouse_over_valid_area := false

func _ready() -> void:
	if not Engine.is_editor_hint():
		EnemyEvents.enemy_spawned.connect(_on_enemy_spawned)

		GameEvents.game_started.connect(_on_game_events_game_started)
		GameEvents.path_previewed.connect(_on_game_events_path_previewed)

		TowerEvents.tower_placing_started.connect(_on_tower_placing_started)

		WavesManager.waves_began.connect(_on_waves_manager_waves_began)

	set_active_path()

func set_active_path() -> void:
	print("Setting active path " + str(active_path_index))

	for i in range(paths.size()):
		if i == active_path_index:
			paths[i].enable_path()

			if not Engine.is_editor_hint():
				paths[i].mouse_validity_changed.connect(_on_path_mouse_validity_changed)
				paths[i].valid_area_clicked.connect(_on_path_valid_area_clicked)
		else:
			paths[i].disable_path()

			if paths[i].mouse_validity_changed.is_connected(_on_path_mouse_validity_changed):
				paths[i].mouse_validity_changed.disconnect(_on_path_mouse_validity_changed)

			if paths[i].valid_area_clicked.is_connected(_on_path_valid_area_clicked):
				paths[i].valid_area_clicked.disconnect(_on_path_valid_area_clicked)

func get_active_path():
	return paths[active_path_index]

func _on_enemy_spawned(enemy: Enemy) -> void:
	get_active_path().add_enemy(enemy)

func _on_game_events_path_previewed(path_index: int) -> void:
	active_path_index = path_index

func _on_game_events_game_started(path_index: int) -> void:
	active_path_index = path_index

func _on_waves_manager_waves_began() -> void:
	get_active_path().start_game()

func _on_path_mouse_validity_changed(is_valid: bool) -> void:
	if is_valid:
		# print("Valid area entered")
		is_mouse_over_valid_area = true

		PathInteraction.emit_mouse_validity_changed(true)
	else:
		# print("Valid area exited")
		is_mouse_over_valid_area = false

		PathInteraction.emit_mouse_validity_changed(false)

func _on_path_valid_area_clicked() -> void:
	if is_mouse_over_valid_area:
		PathInteraction.emit_valid_area_clicked()

func _on_tower_placing_started(_tower: Tower) -> void:
	PathInteraction.emit_mouse_validity_changed(is_mouse_over_valid_area)
