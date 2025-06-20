class_name Explosion extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func explode():
	animation_player.play("explode")
