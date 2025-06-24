class_name EnemyStateData

var _effect: Effect

static func build() -> EnemyStateData:
	return EnemyStateData.new()

func with_effect(effect: Effect) -> EnemyStateData:
	_effect = effect
	return self

func get_effect() -> Effect:
	return _effect
