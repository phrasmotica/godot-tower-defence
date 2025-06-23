class_name WaveFactory

var _boss_enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_boss.tscn")
var _enemy_scene: PackedScene = preload("res://scenes/enemies/enemy_1.tscn")
var _wave_collection: WaveCollection = preload("res://resources/waves/waves_path0.tres")

var _last_index := -1
var _current_index := -1

func _init(last_index) -> void:
	_last_index = last_index

func is_waiting_to_start() -> bool:
	return _current_index == -1

func restart() -> void:
	_current_index = -1

func create() -> Wave:
	if _current_index >= _last_index:
		return null

	_current_index += 1

	var wave := _wave_collection.get_wave(_current_index)

	if wave == null:
		wave = Wave.new()

		var is_boss_wave := _is_boss_wave()

		wave.enemy = _boss_enemy_scene if is_boss_wave else _enemy_scene
		wave.spawn_count = int(_current_index / 5.0) if is_boss_wave else _current_index

	wave.number = _current_index + 1

	return wave

func _is_boss_wave() -> bool:
	return _current_index % 5 == 4
