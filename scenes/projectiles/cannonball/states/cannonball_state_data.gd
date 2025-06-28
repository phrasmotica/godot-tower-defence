class_name CannonballStateData

var _enemy: Enemy

static func build() -> CannonballStateData:
	return CannonballStateData.new()

func with_enemy(enemy: Enemy) -> CannonballStateData:
	_enemy = enemy
	return self

func get_enemy() -> Enemy:
	return _enemy
