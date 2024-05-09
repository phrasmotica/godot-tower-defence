class_name Projectile extends Node2D

var damage: int = 1

func _process(delta):
    # TODO: ditch this, have the tower move me towards the nearest enemy
    position.x += 1
