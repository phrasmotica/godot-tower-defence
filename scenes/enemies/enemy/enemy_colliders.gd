class_name EnemyColliders
extends Node2D

@export
var collision_area: Area2D

signal projectile_entered(projectile: Projectile)

func _ready() -> void:
	collision_area.body_entered.connect(projectile_entered.emit)
