class_name RicochetBulletStateData

var _enemy: Enemy

static func build() -> RicochetBulletStateData:
	return RicochetBulletStateData.new()

func with_enemy(enemy: Enemy) -> RicochetBulletStateData:
	_enemy = enemy
	return self

func get_enemy() -> Enemy:
	return _enemy
