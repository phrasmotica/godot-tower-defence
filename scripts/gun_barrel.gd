class_name GunBarrel extends Node2D

@export var projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var bullet = projectile.instantiate()
	bullet.position.x += 50

	add_child(bullet)
