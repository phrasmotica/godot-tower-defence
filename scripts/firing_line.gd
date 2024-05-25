class_name FiringLine extends Node2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var line: Line2D = $Line
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var enabled := true

func _ready():
	line.hide()

func set_target(projectile_range: int):
	ray_cast.target_position = Vector2(projectile_range * 100, 0)

func can_see_enemies():
	return ray_cast.is_colliding()

# TODO: move all of this enemy-damaging logic to a child node
func fire(bolt_stats: TowerLevelStats):
	animation_player.play("fire")

	var enemy_collider = ray_cast.get_collider()

	if bolt_stats.infinite_penetration:
		while enemy_collider != null:
			enemy_collider = process_enemy(enemy_collider, bolt_stats)
	else:
		process_enemy(enemy_collider, bolt_stats)

	ray_cast.clear_exceptions()

func process_enemy(enemy_collider: CollisionObject2D, bolt_stats: TowerLevelStats):
	damage_enemy(enemy_collider, bolt_stats)
	return next_enemy()

func damage_enemy(enemy_collider: CollisionObject2D, bolt_stats: TowerLevelStats):
	var enemy := (enemy_collider as CollisionObject2D).get_parent() as Enemy
	enemy.handle_bolt(bolt_stats)
	ray_cast.add_exception(enemy_collider)

func next_enemy():
	ray_cast.force_raycast_update()
	return ray_cast.get_collider()
