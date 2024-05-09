class_name Path extends Path2D

var enemies: Array[Enemy] = []

signal enemy_reached_end(enemy: Enemy)

@export var enemy_scene: PackedScene

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		spawn_enemy()

func spawn_enemy():
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.reached_end.connect(_on_enemy_reached_end)

	add_child(enemy)
	enemies.append(enemy)

func _on_enemy_reached_end(enemy: Enemy):
	enemy_reached_end.emit(enemy)
