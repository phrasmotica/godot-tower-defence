class_name Path extends Path2D

signal enemy_reached_end(enemy: Enemy)

func _on_enemy_1_reached_end(enemy: Enemy):
	enemy_reached_end.emit(enemy)
