class_name Projectile extends Node2D

var damage: int = 1
var speed: int = 10

var direction: Vector2

func _process(delta):
    translate(direction * speed)
