class_name ProjectileColliders
extends Node2D

@export
var collision_area: ProjectileArea2D

signal enemy_hit(enemy: Enemy)

func _ready() -> void:
	collision_area.area_entered.connect(_handle_area_entered)

func setup(projectile: Projectile) -> void:
	collision_area.setup(projectile)

func disable() -> void:
	collision_area.set_deferred("monitorable", false)
	collision_area.set_deferred("monitoring", false)

func _handle_area_entered(enemy_body: EnemyArea2D) -> void:
	var enemy := enemy_body.get_enemy()
	enemy_hit.emit(enemy)
