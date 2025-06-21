class_name GameUIStateData

var _tower_scene: PackedScene
var _placing_tower: Tower

static func build() -> GameUIStateData:
	return GameUIStateData.new()

func with_placing_tower(placing_tower: Tower) -> GameUIStateData:
	_placing_tower = placing_tower
	return self

func get_placing_tower() -> Tower:
	return _placing_tower

func with_tower_scene(tower_scene: PackedScene) -> GameUIStateData:
	_tower_scene = tower_scene
	return self

func get_tower_scene() -> PackedScene:
	return _tower_scene
