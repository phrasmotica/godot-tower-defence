class_name GunBarrel extends Node2D

@export var projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var bullet: Projectile = projectile.instantiate()
	add_child(bullet)
