class_name EnemyColliders
extends Node2D

@export
var collision_area: EnemyArea2D

signal projectile_entered(projectile: Projectile)

func _ready() -> void:
	collision_area.area_entered.connect(_handle_area_entered)

func setup(enemy: Enemy) -> void:
	collision_area.setup(enemy)

func _handle_area_entered(area: ProjectileArea2D) -> void:
	var projectile := area.get_projectile()
	projectile_entered.emit(projectile)
