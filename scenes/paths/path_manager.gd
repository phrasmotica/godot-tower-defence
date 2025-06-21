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

var enemies: Array[Enemy] = []

signal mouse_validity_changed(is_valid: bool)
signal valid_area_clicked

signal enemy_died(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func _ready() -> void:
	if not Engine.is_editor_hint():
		LivesManager.setup(self)

		WavesManager.setup(self)
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

func spawn_enemy(enemy_scene: PackedScene):
	var enemy = get_active_path().spawn_enemy(enemy_scene)

	enemy.die.connect(_on_enemy_die)
	enemy.reached_end.connect(_on_enemy_reached_end)

	enemies.append(enemy)

	return enemy

func remove_enemy(enemy: Enemy):
	enemies.erase(enemy)

func _on_enemy_die(enemy: Enemy):
	remove_enemy(enemy)

	enemy_died.emit(enemy)

	BankManager.earn(enemy.bounty)

func _on_enemy_reached_end(enemy: Enemy):
	remove_enemy(enemy)
	enemy.queue_free()

	enemy_reached_end.emit(enemy)

func _on_start_game_preview(path_index:int):
	active_path_index = path_index

func _on_start_game_start(path_index: int):
	active_path_index = path_index

func _on_waves_manager_waves_began():
	get_active_path().start_game()

func _on_path_mouse_validity_changed(is_valid: bool) -> void:
	if is_valid:
		print("Valid area entered")
		is_mouse_over_valid_area = true

		mouse_validity_changed.emit(true)
	else:
		print("Valid area exited")
		is_mouse_over_valid_area = false

		mouse_validity_changed.emit(false)

func _on_path_valid_area_clicked() -> void:
	if is_mouse_over_valid_area:
		valid_area_clicked.emit()

func _on_game_ui_tower_placing(_tower: Tower):
	mouse_validity_changed.emit(is_mouse_over_valid_area)
