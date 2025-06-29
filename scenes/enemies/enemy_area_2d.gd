class_name EnemyArea2D
extends Area2D

var _parent_enemy: Enemy = null

func setup(enemy: Enemy) -> void:
	_parent_enemy = enemy

func get_enemy() -> Enemy:
	return _parent_enemy
