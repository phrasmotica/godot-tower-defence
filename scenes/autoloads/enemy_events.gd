extends Node

signal enemy_died(enemy: Enemy)
signal enemy_spawned(enemy: Enemy)
signal enemy_reached_end(enemy: Enemy)

func emit_enemy_died(enemy: Enemy) -> void:
	enemy_died.emit(enemy)

func emit_enemy_spawned(enemy: Enemy) -> void:
	enemy_spawned.emit(enemy)

func emit_enemy_reached_end(enemy: Enemy) -> void:
	enemy_reached_end.emit(enemy)
