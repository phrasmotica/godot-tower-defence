class_name CannonballAppearance
extends Node2D

@export
var sprite: AnimatedSprite2D

func for_explosion(explosion: Explosion) -> void:
	sprite.hide()

	add_child(explosion)
