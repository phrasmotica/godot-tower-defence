class_name EnemyColliders
extends Node2D

@export
var collision_area: EnemyArea2D

signal projectile_entered(projectile: Projectile)

func _ready() -> void:
	collision_area.body_entered.connect(_handle_body_entered)

func setup(enemy: Enemy) -> void:
	collision_area.setup(enemy)

func _handle_body_entered(body: Projectile) -> void:
	projectile_entered.emit(body)
