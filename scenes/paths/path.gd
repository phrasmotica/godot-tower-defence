@tool
class_name Path extends Node2D

@export
var tile_map_layer: TileMapLayer

@export
var path_waypoints: Path2D

@export
var start_arrow: Node2D

@export
var valid_placement_area: Area2D

var original_tile_set: TileSet

signal mouse_validity_changed(is_valid: bool)
signal valid_area_clicked

func _ready() -> void:
	original_tile_set = tile_map_layer.tile_set

	if not Engine.is_editor_hint():
		valid_placement_area.mouse_entered.connect(_on_path_mouse_entered)
		valid_placement_area.mouse_exited.connect(_on_path_mouse_exited)
		valid_placement_area.input_event.connect(_on_valid_placement_area_input_event)

func enable_path():
	valid_placement_area.input_pickable = true
	show()

	if not tile_map_layer.tile_set:
		tile_map_layer.tile_set = original_tile_set

func disable_path():
	valid_placement_area.input_pickable = false
	hide()

	tile_map_layer.tile_set = null

func start_game():
	start_arrow.hide()

func add_enemy(enemy: Enemy) -> void:
	path_waypoints.add_child(enemy)

func _on_path_mouse_entered() -> void:
	mouse_validity_changed.emit(true)

func _on_path_mouse_exited() -> void:
	mouse_validity_changed.emit(false)

func _on_valid_placement_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_pressed():
		valid_area_clicked.emit()
